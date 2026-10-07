// chapters.js 에 정의된 CHAPTERS 배열을 사용합니다 (convert.sh 가 자동 생성).
// 형식: [{ id: "ch1", title: "Chapter 1. 제목", pages: 12 }, ...]

const tabsEl = document.getElementById("tabs");
const aboutTab = document.getElementById("aboutTab");
const aboutView = document.getElementById("aboutView");
const chapterView = document.getElementById("chapterView");
const pagerEl = document.getElementById("pager");
const pagesEl = document.getElementById("pages");
const titleEl = document.getElementById("chapterTitle");
const emptyEl = document.getElementById("empty");
const prevBtn = document.getElementById("prevBtn");
const nextBtn = document.getElementById("nextBtn");
const pagerInfo = document.getElementById("pagerInfo");

let current = 0;          // 현재 챕터 인덱스
let chapterBtns = [];

function pad(n) {
  return String(n).padStart(2, "0");
}

// 챕터 탭 버튼 생성 (강사 소개 버튼 오른쪽에 추가)
function buildTabs() {
  CHAPTERS.forEach((ch, i) => {
    const btn = document.createElement("button");
    btn.textContent = ch.title.split(".")[0]; // "Chapter 1"
    btn.title = ch.title;
    btn.onclick = () => showChapter(i);
    tabsEl.appendChild(btn);
    chapterBtns.push(btn);
  });
}

function setActive(btn) {
  tabsEl.querySelectorAll("button").forEach(b => b.classList.remove("active"));
  btn.classList.add("active");
}

function showAbout() {
  location.hash = "about";
  aboutView.hidden = false;
  chapterView.hidden = true;
  pagerEl.hidden = true;
  setActive(aboutTab);
  window.scrollTo({ top: 0 });
}

function showChapter(i) {
  current = i;
  const ch = CHAPTERS[i];
  location.hash = ch.id;

  aboutView.hidden = true;
  chapterView.hidden = false;
  pagerEl.hidden = CHAPTERS.length < 2;   // 챕터가 하나뿐이면 이전/다음 숨김

  titleEl.textContent = ch.title;
  pagesEl.innerHTML = "";
  emptyEl.hidden = ch.pages > 0;

  for (let p = 1; p <= ch.pages; p++) {
    const img = document.createElement("img");
    img.src = `pages/${ch.id}/${pad(p)}.webp`;
    img.alt = `${ch.title} - ${p}페이지`;
    img.loading = "lazy";
    pagesEl.appendChild(img);
  }

  prevBtn.disabled = i === 0;
  nextBtn.disabled = i === CHAPTERS.length - 1;
  pagerInfo.textContent = `${i + 1} / ${CHAPTERS.length}`;

  setActive(chapterBtns[i]);
  window.scrollTo({ top: 0 });
}

aboutTab.onclick = showAbout;
prevBtn.onclick = () => current > 0 && showChapter(current - 1);
nextBtn.onclick = () => current < CHAPTERS.length - 1 && showChapter(current + 1);

buildTabs();

// URL 해시로 바로 접근: #about, #ch1 ~ #ch5
if (location.hash === "#about") {
  showAbout();
} else {
  const idx = CHAPTERS.findIndex(c => "#" + c.id === location.hash);
  showChapter(idx >= 0 ? idx : 0);
}
