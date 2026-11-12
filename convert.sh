#!/bin/bash
# PDF -> 페이지별 WebP 이미지 변환 + chapters.js 자동 생성
#
# 사용법:
#   1. pdf/ 폴더에 ch1.pdf, ch2.pdf, ... ch5.pdf 를 넣는다
#   2. ./convert.sh 실행
#   3. pages/chN/01.webp ... 와 chapters.js 가 생성된다
#
# 챕터 제목을 바꾸려면 아래 TITLES 를 수정하세요.

set -e
cd "$(dirname "$0")"

DPI=${DPI:-110}   # 해상도. 선명하게 하려면 150, 용량 줄이려면 90

# 웹사이트에 공개할 챕터 번호. 나중에 "1 2 3 4 5" 처럼 추가하면 됩니다.
PUBLISH="1 2 3 4"

declare -a TITLES=(
  "Chapter 1. 마케팅에 대한 이해 및 AI를 활용한 마케팅"
  "Chapter 2. 가장 쉽게 배우는 광고 소재 기획"
  "Chapter 3. 광고 랜딩페이지와 콘텐츠 전환 구조 설계"
  "Chapter 4. 데이터로 말하는 퍼포먼스 마케팅"
  "Chapter 5. 제목을 입력하세요"
)

if ! command -v pdftoppm >/dev/null || ! command -v cwebp >/dev/null; then
  echo "필요한 도구가 없습니다. 설치: brew install poppler webp"; exit 1
fi

echo "const CHAPTERS = [" > chapters.js

for i in 1 2 3 4 5; do
  id="ch$i"
  pdf="pdf/$id.pdf"
  out="pages/$id"
  title="${TITLES[$((i-1))]}"
  mkdir -p "$out"

  # 공개 목록에 없는 챕터는 건너뜀 (이미지는 건드리지 않음)
  if [[ " $PUBLISH " != *" $i "* ]]; then
    echo "[$id] 비공개 - 건너뜀"
    continue
  fi

  if [ -f "$pdf" ]; then
    # PDF 가 이미지보다 새 파일이거나 이미지가 없을 때만 변환 (FORCE=1 로 강제)
    if [ "${FORCE:-0}" = "1" ] || [ -z "$(ls "$out"/*.webp 2>/dev/null)" ] || [ "$pdf" -nt "$out/01.webp" ]; then
      echo "[$id] 변환 중: $pdf"
      rm -f "$out"/*.webp
      if [ "$id" = "ch2" ]; then
        # Chapter 2는 110페이지까지만 공개
        pdftoppm -f 1 -l 110 -r "$DPI" -png "$pdf" "$out/p" 2>/dev/null
      else
        pdftoppm -r "$DPI" -png "$pdf" "$out/p" 2>/dev/null
      fi
      n=0
      for f in "$out"/p-*.png; do
        [ -e "$f" ] || continue
        n=$((n+1))
        num=$(printf "%02d" "$n")
        cwebp -quiet -q 82 "$f" -o "$out/$num.webp"
        rm -f "$f"
      done
      echo "  -> $n 페이지"
    else
      n=$(ls "$out"/*.webp | wc -l | tr -d ' ')
      # Chapter 1의 67·68페이지는 공개하지 않으므로 기존 이미지 수에 포함되지 않음
      if [ "$id" = "ch1" ]; then n=$((n+2)); fi
      # Chapter 3의 마지막 공개 이미지는 61페이지 (중간 54~60 제외)
      if [ "$id" = "ch3" ]; then
        for f in "$out"/*.webp; do
          page=$(basename "$f" .webp)
          if (( 10#$page > n )); then n=$((10#$page)); fi
        done
      fi
      if [ "$id" = "ch4" ]; then n=39; fi
      echo "[$id] 변환 생략 (이미 $n 페이지 있음)"
    fi
  else
    echo "[$id] $pdf 없음 - 건너뜀"
    continue
  fi

  # Chapter 1에서는 67·68페이지만 제외하고 69페이지는 유지
  if [ "$id" = "ch1" ]; then
    rm -f "$out/67.webp" "$out/68.webp"
  fi
  if [ "$id" = "ch2" ]; then
    rm -f "$out/111.webp" "$out/112.webp" "$out/113.webp" "$out/114.webp"
  fi
  if [ "$id" = "ch3" ]; then
    rm -f "$out"/{54,55,56,57,58,59,60}.webp
  fi
  if [ "$id" = "ch4" ]; then
    # 새 PDF의 1·2페이지를 각각 33·34페이지에 넣고, 36페이지는 제외
    replacement="pdf/ch4-replacement.pdf"
    if [ -f "$replacement" ] && { [ "${FORCE:-0}" = "1" ] || [ "$replacement" -nt "$out/33.webp" ] || [ "$replacement" -nt "$out/34.webp" ]; }; then
      for page in 1 2; do
        target=$((page+32))
        pdftoppm -f "$page" -l "$page" -singlefile -r "$DPI" -png "$replacement" "$out/replacement" 2>/dev/null
        cwebp -quiet -q 82 "$out/replacement.png" -o "$out/$target.webp"
        rm -f "$out/replacement.png"
      done
    fi
    rm -f "$out/36.webp"
    # 추가 PDF는 기존 39페이지 뒤에 이어 붙입니다 (40페이지부터).
    appendix="pdf/ch4-append.pdf"
    if [ -f "$appendix" ]; then
      added=$(pdfinfo "$appendix" | awk '/^Pages:/ {print $2}')
      if [ "${FORCE:-0}" = "1" ] || [ ! -f "$out/40.webp" ] || [ "$appendix" -nt "$out/40.webp" ]; then
        rm -f "$out"/{40..73}.webp "$out"/append-*.png
        pdftoppm -r "$DPI" -png "$appendix" "$out/append" 2>/dev/null
        page=39
        for f in "$out"/append-*.png; do
          [ -e "$f" ] || continue
          page=$((page+1))
          cwebp -quiet -q 82 "$f" -o "$out/$page.webp"
          rm -f "$f"
        done
        [ "$page" -eq $((39+added)) ] || { echo "추가 PDF 변환 페이지 수가 일치하지 않습니다"; exit 1; }
      fi
      n=$((39+added))
    else
      n=39
    fi
    # 두 번째 추가 PDF는 앞의 34페이지가 끝난 뒤(74페이지부터) 이어 붙입니다.
    appendix2="pdf/ch4-append-2.pdf"
    if [ -f "$appendix2" ]; then
      added2=$(pdfinfo "$appendix2" | awk '/^Pages:/ {print $2}')
      if [ "${FORCE:-0}" = "1" ] || [ ! -f "$out/74.webp" ] || [ "$appendix2" -nt "$out/74.webp" ]; then
        rm -f "$out"/{74..99}.webp "$out"/append2-*.png
        pdftoppm -r "$DPI" -png "$appendix2" "$out/append2" 2>/dev/null
        page=73
        for f in "$out"/append2-*.png; do
          [ -e "$f" ] || continue
          page=$((page+1))
          cwebp -quiet -q 82 "$f" -o "$out/$page.webp"
          rm -f "$f"
        done
        [ "$page" -eq $((73+added2)) ] || { echo "두 번째 추가 PDF 변환 페이지 수가 일치하지 않습니다"; exit 1; }
      fi
      n=$((73+added2))
    fi
    # 광고 의사결정 '언제 버틴다' 슬라이드(96페이지) 교체.
    hold_replacement="pdf/ch4-hold-replacement.pdf"
    if [ -f "$hold_replacement" ] && { [ "${FORCE:-0}" = "1" ] || [ "$hold_replacement" -nt "$out/96.webp" ]; }; then
      pdftoppm -f 1 -l 1 -singlefile -r "$DPI" -png "$hold_replacement" "$out/hold-replacement" 2>/dev/null
      cwebp -quiet -q 82 "$out/hold-replacement.png" -o "$out/96.webp"
      rm -f "$out/hold-replacement.png"
    fi
    # 세 번째 추가 PDF는 '언제 버틴다' 다음인 97페이지부터 이어 붙입니다.
    appendix3="pdf/ch4-append-3.pdf"
    if [ -f "$appendix3" ]; then
      added3=$(pdfinfo "$appendix3" | awk '/^Pages:/ {print $2}')
      if [ "${FORCE:-0}" = "1" ] || [ ! -f "$out/97.webp" ] || [ "$appendix3" -nt "$out/97.webp" ]; then
        rm -f "$out"/{97..126}.webp "$out"/append3-*.png
        pdftoppm -r "$DPI" -png "$appendix3" "$out/append3" 2>/dev/null
        page=96
        for f in "$out"/append3-*.png; do
          [ -e "$f" ] || continue
          page=$((page+1))
          cwebp -quiet -q 82 "$f" -o "$out/$page.webp"
          rm -f "$f"
        done
        [ "$page" -eq $((96+added3)) ] || { echo "세 번째 추가 PDF 변환 페이지 수가 일치하지 않습니다"; exit 1; }
      fi
      n=$((96+added3))
    fi
  fi
  echo "  { id: \"$id\", title: \"$title\", pages: $n }," >> chapters.js
done

echo "];" >> chapters.js
echo "완료. chapters.js 생성됨."
