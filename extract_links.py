"""원본 PDF의 외부 링크 주석을 이미지 위에 배치할 좌표로 추출합니다.

사용법: python3 extract_links.py
사전 설치: python3 -m pip install pymupdf
"""

import json
import re
from pathlib import Path

import fitz


ROOT = Path(__file__).resolve().parent
CHAPTERS = {
    "ch1": {"last_page": 69, "hidden": {67, 68}},
    "ch2": {"last_page": 110, "hidden": set()},
}

URL_TEXT = re.compile(
    r"(?<![\w@])(?:https?://|www\.)?"
    r"(?:[A-Za-z0-9-]+\.)+(?:com|net|org|io|kr|ai|edu)"
    r"(?:/[A-Za-z0-9@%?&=+.#~/_-]*)?",
    re.IGNORECASE,
)

# URL 대신 서비스 이름만 적힌 도구 소개 슬라이드의 공식 사이트
NAMED_LINKS = {
    "ch2": {
        91: {
            "미리캔버스": "https://www.miricanvas.com/ko",
            "Canva": "https://www.canva.com/ko_kr/",
            "브이캣": "https://vcat.ai/",
        },
        108: {"미리캔버스": "https://www.miricanvas.com/ko"},
    },
}


def region(rect, page, url):
    """PDF 좌표를 반응형 이미지에서도 유지되는 % 좌표로 변환합니다."""
    return {
        "url": url,
        "x": round(100 * (rect.x0 - page.rect.x0) / page.rect.width, 4),
        "y": round(100 * (rect.y0 - page.rect.y0) / page.rect.height, 4),
        "width": round(100 * rect.width / page.rect.width, 4),
        "height": round(100 * rect.height / page.rect.height, 4),
    }


def extract():
    result = {}
    for chapter, config in CHAPTERS.items():
        pdf = ROOT / "pdf" / f"{chapter}.pdf"
        if not pdf.exists():
            continue
        pages = {}
        with fitz.open(pdf) as document:
            for index in range(min(len(document), config["last_page"])):
                page_number = index + 1
                if page_number in config["hidden"]:
                    continue
                page = document[index]
                links = []
                annotation_rects = []
                for link in page.get_links():
                    if link["kind"] != fitz.LINK_URI:
                        continue
                    url = link.get("uri", "")
                    if not url.startswith(("https://", "http://")):
                        continue
                    rect = link["from"] & page.rect
                    if rect.is_empty:
                        continue
                    links.append(region(rect, page, url))
                    annotation_rects.append(rect)

                # PDF 주석 없이 화면에 주소만 인쇄된 슬라이드도 클릭할 수 있게 합니다.
                for match in URL_TEXT.finditer(page.get_text()):
                    label = match.group().rstrip(".,;:)")
                    url = label if label.startswith(("https://", "http://")) else "https://" + label
                    for rect in page.search_for(label):
                        rect = rect & page.rect
                        if rect.is_empty or any(not (rect & existing).is_empty for existing in annotation_rects):
                            continue
                        links.append(region(rect, page, url))

                for label, url in NAMED_LINKS.get(chapter, {}).get(page_number, {}).items():
                    for rect in page.search_for(label):
                        links.append(region(rect & page.rect, page, url))
                if links:
                    pages[str(page_number)] = links
        if pages:
            result[chapter] = pages
    return result


if __name__ == "__main__":
    links = extract()
    (ROOT / "links.js").write_text(
        "// PDF의 외부 링크 위치 (extract_links.py 생성)\n"
        "const PAGE_LINKS = " + json.dumps(links, ensure_ascii=False, indent=2) + ";\n",
        encoding="utf-8",
    )
    print("links.js 생성 완료:", sum(len(page) for chapter in links.values() for page in chapter.values()), "개 링크")
