const state = {
  search: "",
  rankTab: "month",
  selectedDay: 21,
  points: 880,
  clubs: [
    {
      id: "c1",
      name: "Lithappened",
      description: "Editorial discussions, shared reading goals, and a little competitive sparkle.",
      privacy: "PUBLIC",
      memberCount: 12,
      currentBook: "The Midnight Library",
      currentBookId: "b2",
      progress: 72,
      coverClass: "cover-purple",
      accent: "purple",
      joined: true,
    },
    {
      id: "c2",
      name: "The Quiet Chapter",
      description: "A cozy circle for reflective readers who like thoughtful prompts and soft pacing.",
      privacy: "PRIVATE",
      memberCount: 8,
      currentBook: "Piranesi",
      currentBookId: "b3",
      progress: 41,
      coverClass: "cover-warm",
      accent: "warm",
      joined: false,
    },
    {
      id: "c3",
      name: "Paper Moon Society",
      description: "For whimsical readers who love monthly draws, challenges, and richly layered stories.",
      privacy: "INVITE ONLY",
      memberCount: 15,
      currentBook: "Tomorrow, and Tomorrow, and Tomorrow",
      currentBookId: "b1",
      progress: 67,
      coverClass: "cover-purple",
      accent: "warm",
      joined: true,
    },
  ],
  readings: [
    { id: "r1", clubId: "c3", bookId: "b1", title: "Tomorrow, and Tomorrow, and Tomorrow", author: "Gabrielle Zevin", progress: 67, currentPage: 268, totalPages: 400, deadline: "12 days remaining", club: "Paper Moon Society", membersReading: 9, membersFinished: 3, avgProgress: 64, startDate: "1 Aug", endDate: "1 Sep", milestones: ["START", "Chapter 5", "Chapter 10", "Midpoint", "Final"] },
    { id: "r2", clubId: "c1", bookId: "b2", title: "The Midnight Library", author: "Matt Haig", progress: 72, currentPage: 218, totalPages: 304, deadline: "10 days remaining", club: "Lithappened", membersReading: 12, membersFinished: 7, avgProgress: 72, startDate: "5 Aug", endDate: "5 Sep", milestones: ["START", "Chapter 5", "Chapter 10", "Midpoint", "Final"] },
  ],
  rankings: {
    month: [
      { rank: 1, name: "Luna", level: 13, points: 920 },
      { rank: 2, name: "Clara", level: 11, points: 870 },
      { rank: 3, name: "You", level: 12, points: 880 },
      { rank: 4, name: "Sofia", level: 10, points: 770 },
      { rank: 5, name: "Milo", level: 9, points: 740 },
    ],
    year: [
      { rank: 1, name: "Luna", level: 13, points: 3880 },
      { rank: 2, name: "You", level: 12, points: 3520 },
      { rank: 3, name: "Clara", level: 11, points: 3410 },
      { rank: 4, name: "Sofia", level: 10, points: 3090 },
      { rank: 5, name: "Milo", level: 9, points: 2840 },
    ],
    all: [
      { rank: 1, name: "Luna", level: 13, points: 8200 },
      { rank: 2, name: "Clara", level: 11, points: 7900 },
      { rank: 3, name: "You", level: 12, points: 7640 },
      { rank: 4, name: "Sofia", level: 10, points: 7110 },
      { rank: 5, name: "Milo", level: 9, points: 6490 },
    ],
  },
  challenges: [
    { title: "Read 500 pages in September", description: "Keep the pace warm and steady.", progress: 320, goal: 500, reward: 200, status: "Active" },
    { title: "Finish 2 club books", description: "Sync your reading with your club schedule.", progress: 1, goal: 2, reward: 150, status: "Active" },
    { title: "Leave 5 thoughtful comments", description: "Add kindness and perspective to the discussion.", progress: 5, goal: 5, reward: 120, status: "Completed" },
    { title: "Attend 3 meetings", description: "Show up for the cozy club rhythm.", progress: 1, goal: 3, reward: 180, status: "Upcoming" },
  ],
  rewards: [
    { name: "Choose next month's book", description: "Guide the next club pick.", cost: 300, icon: "🗳️" },
    { name: "Custom profile badge", description: "Design a badge that appears on your profile.", cost: 500, icon: "✨" },
    { name: "Skip one challenge", description: "Opt out of a weekly challenge once.", cost: 400, icon: "⏭️" },
    { name: "Special club role for one week", description: "Become a spotlight host in your club.", cost: 700, icon: "👑" },
  ],
  events: [
    { title: "Mid-month reflection", date: "Aug 21 • 19:00", type: "Meeting", club: "Lithappened" },
    { title: "Reading sprint", date: "Aug 22 • 18:30", type: "Event", club: "Paper Moon Society" },
    { title: "Deadline reminder", date: "Aug 24 • 09:00", type: "Deadline", club: "The Quiet Chapter" },
    { title: "Challenge launch", date: "Aug 27 • 08:00", type: "Challenge", club: "Paper Moon Society" },
  ],
  notifications: [
    { title: "New club meeting", body: "Lithappened scheduled a mid-month reflection.", type: "meeting" },
    { title: "Reading deadline", body: "Piranesi closes in 4 days.", type: "deadline" },
    { title: "Achievement unlocked", body: "Discussion Spark is now yours.", type: "achievement" },
    { title: "Club invitation", body: "Paper Moon Society invited you to a draw.", type: "invite" },
  ],
  achievements: ["📚 First Club", "☕ Weekend Reader", "🛡️ Spoiler Shield", "💬 Discussion Spark", "🌸 Book Bloom"],
  comments: [
    { user: "Luna", body: "The emotional arc feels intimate and incredibly lived in.", spoilerPage: null, bookId: "b1" },
    { user: "Clara", body: "This comment contains spoilers up to page 180. The late twist reframes the whole friendship.", spoilerPage: 180, bookId: "b1" },
    { user: "Milo", body: "The structure itself mirrors the game logic in a way that is quietly brilliant.", spoilerPage: null, bookId: "b1" },
    { user: "Sofia", body: "A hopeful, reflective club read with a beautiful cadence.", spoilerPage: null, bookId: "b2" },
    { user: "You", body: "This comment contains spoilers up to page 220. The library choice lands emotionally.", spoilerPage: 220, bookId: "b2" },
  ],
  selection: {
    c1: { mode: "voting", books: ["b4", "b5", "b6"], votes: [12, 18, 7] },
    c3: { mode: "draw", books: ["b1", "b2", "b5"], selected: null },
  },
  bookMeta: {
    b1: { title: "Tomorrow, and Tomorrow, and Tomorrow", author: "Gabrielle Zevin", color: "purple" },
    b2: { title: "The Midnight Library", author: "Matt Haig", color: "periwinkle" },
    b3: { title: "Piranesi", author: "Susanna Clarke", color: "warm" },
    b4: { title: "The Secret History", author: "Donna Tartt", color: "warm" },
    b5: { title: "The House in the Cerulean Sea", author: "TJ Klune", color: "purple" },
    b6: { title: "Lessons in Chemistry", author: "Bonnie Garmus", color: "periwinkle" },
  },
};

const el = (sel) => document.querySelector(sel);
const fmt = (n) => new Intl.NumberFormat().format(n);

function bookTitle(id) {
  return state.bookMeta[id]?.title ?? "";
}

function renderClubs() {
  const query = state.search.toLowerCase();
  const clubs = state.clubs.filter((club) => {
    if (!query) return true;
    return [club.name, club.description, club.privacy].some((value) => value.toLowerCase().includes(query));
  });

  el("#clubs-grid").innerHTML = clubs
    .map((club) => {
      const current = club.joined
        ? `<div class="book-tag"><span class="pill">${club.currentBook}</span></div>`
        : `<div class="sidebar-card"><p>Join this club to see the current book and reading progress.</p></div>`;
      return `
        <article class="club-card">
          <div class="club-cover ${club.coverClass}">
            <div class="eyebrow">${club.privacy}</div>
            <strong>${club.name}</strong>
            <span>${club.description}</span>
          </div>
          <div class="card-header">
            <div>
              <div class="eyebrow">Current book</div>
              ${current}
            </div>
            <span class="pill">${club.joined ? `${club.progress}%` : club.privacy}</span>
          </div>
          <p class="muted">${club.joined ? `${club.memberCount} members • Joined` : `${club.memberCount} members`}</p>
          <div class="button-row">
            <button class="secondary-btn" data-action="toggle-join" data-id="${club.id}">${club.joined ? "Leave club" : "Join club"}</button>
            ${club.privacy !== "PUBLIC" ? `<button class="secondary-btn" data-action="request-access" data-id="${club.id}">Request access</button>` : ""}
          </div>
        </article>
      `;
    })
    .join("");
}

function renderSelection() {
  const joinedClubs = state.clubs.filter((club) => club.joined);
  el("#selection-panel").innerHTML = joinedClubs
    .map((club) => {
      const selection = state.selection[club.id];
      if (!selection) return "";

      if (selection.mode === "voting") {
        return `
          <article class="selection-card">
            <div class="card-header">
              <div>
                <div class="eyebrow">${club.name}</div>
                <strong>Voting</strong>
              </div>
              <span class="pill">VOTING</span>
            </div>
            ${selection.books
              .map((bookId, index) => `
                <div class="note-card">
                  <div class="card-header">
                    <strong>${bookTitle(bookId)}</strong>
                    <span>${selection.votes[index]} votes</span>
                  </div>
                  <button class="secondary-btn" data-action="vote-book" data-club="${club.id}" data-index="${index}">Vote</button>
                </div>
              `)
              .join("")}
          </article>
        `;
      }

      return `
        <article class="selection-card">
          <div class="card-header">
            <div>
              <div class="eyebrow">${club.name}</div>
              <strong>Draw</strong>
            </div>
            <span class="pill accent">DRAW</span>
          </div>
          <div class="note-card">
            <p class="muted">Reveal the next club pick with a gentle animation.</p>
            ${selection.selected ? `<strong>${bookTitle(selection.selected)}</strong>` : `<button class="primary-btn" data-action="reveal-draw" data-club="${club.id}">Reveal draw</button>`}
          </div>
        </article>
      `;
    })
    .join("");
}

function renderReadings() {
  const readings = state.readings.filter((reading) => state.clubs.some((club) => club.id === reading.clubId && club.joined));
  el("#reading-list").innerHTML = readings
    .map((reading) => {
      const comments = state.comments.filter((comment) => comment.bookId === reading.bookId);
      return `
        <article class="reading-card">
          <div class="book-cover ${reading.bookId === "b1" ? "cover-purple" : "cover-warm"}">
            <span>${reading.title}</span>
            <strong>${reading.author}</strong>
          </div>
          <div>
            <div class="card-header">
              <div>
                <div class="eyebrow">${reading.club}</div>
                <h3>${reading.progress}%</h3>
              </div>
              <div class="pill">${reading.currentPage} / ${reading.totalPages}</div>
            </div>
            <div class="muted">${reading.deadline}</div>
            <div class="progress"><div style="width:${reading.progress}%"></div></div>
            <div class="button-row">
              <button class="primary-btn" data-action="advance-reading" data-id="${reading.id}">Update progress</button>
              <button class="secondary-btn" data-action="complete-reading" data-id="${reading.id}">Mark finished</button>
            </div>
            <div class="grid" style="margin-top:14px;">
              ${comments
                .map((comment, index) => {
                  const locked = comment.spoilerPage && reading.currentPage < comment.spoilerPage;
                  return `
                    <div class="note-card">
                      <div class="card-header">
                        <strong>${comment.user}</strong>
                        ${comment.spoilerPage ? '<span class="pill accent">Spoiler</span>' : ""}
                      </div>
                      <p class="${locked ? "spoiler" : ""}">${comment.body}</p>
                      ${locked ? `<button class="secondary-btn" data-action="reveal-spoiler" data-book="${comment.bookId}" data-index="${index}">Reveal spoiler</button>` : ""}
                    </div>
                  `;
                })
                .join("")}
            </div>
          </div>
        </article>
      `;
    })
    .join("");
}

function renderRanking() {
  const rows = state.rankings[state.rankTab];
  el("#ranking-list").innerHTML = rows
    .map(
      (row) => `
      <div class="ranking-row ${row.rank <= 3 ? "top" : ""}">
        <div class="rank-badge">${row.rank}</div>
        <div class="avatar">${row.name[0]}${row.name[1] ?? ""}</div>
        <div>
          <strong>${row.name}</strong>
          <div class="muted">Level ${row.level}</div>
        </div>
        <strong>${fmt(row.points)} pts</strong>
      </div>
    `,
    )
    .join("");
}

function renderChallenges() {
  el("#challenge-grid").innerHTML = state.challenges
    .map(
      (challenge) => `
        <article class="challenge-card">
          <div class="card-header">
            <strong>${challenge.title}</strong>
            <span class="pill">${challenge.status}</span>
          </div>
          <p class="muted">${challenge.description}</p>
          <div class="progress warm"><div style="width:${Math.min(100, (challenge.progress / challenge.goal) * 100)}%"></div></div>
          <div class="card-header">
            <span>${challenge.progress} / ${challenge.goal}</span>
            <span>+${challenge.reward} points</span>
          </div>
        </article>
      `,
    )
    .join("");
}

function renderRewards() {
  el("#points-balance").textContent = `${state.points} points`;
  el("#rewards-grid").innerHTML = state.rewards
    .map(
      (reward) => `
        <article class="reward-card">
          <div class="card-header">
            <div class="avatar">${reward.icon}</div>
            <strong>${reward.name}</strong>
          </div>
          <p class="muted">${reward.description}</p>
          <div class="card-header">
            <span class="pill">${reward.cost} pts</span>
            <button class="primary-btn" data-action="redeem-reward" data-cost="${reward.cost}" ${state.points < reward.cost ? "disabled" : ""}>Redeem</button>
          </div>
        </article>
      `,
    )
    .join("");
}

function renderNotifications() {
  el("#notifications").innerHTML = state.notifications
    .map(
      (note) => `
        <div class="note-card">
          <strong>${note.title}</strong>
          <p class="muted">${note.body}</p>
        </div>
      `,
    )
    .join("");
}

function renderAchievements() {
  el("#achievements").innerHTML = state.achievements.map((item) => `<span class="badge">${item}</span>`).join("");
}

function renderCalendar() {
  const calendar = el("#calendar");
  calendar.innerHTML = Array.from({ length: 31 }, (_, index) => {
    const day = index + 1;
    const dayEvents = state.events.filter(() => [21, 22, 24, 27].includes(day));
    return `
      <button class="day ${state.selectedDay === day ? "active-day" : ""}" data-action="select-day" data-day="${day}">
        <strong>${day}</strong>
        <div class="dots">${dayEvents.map((event) => `<span class="dot"></span>`).join("")}</div>
      </button>
    `;
  }).join("");

  const selected = state.events.filter(() => [21, 22, 24, 27].includes(state.selectedDay));
  el("#calendar-detail").innerHTML = `
    <div class="eyebrow">Selected day</div>
    <h3>August ${state.selectedDay}</h3>
    <div class="grid">
      ${selected
        .map(
          (event) => `
            <div class="calendar-pill">
              <strong>${event.title}</strong>
              <div class="muted">${event.date}</div>
              <div class="muted">${event.club} • ${event.type}</div>
            </div>
          `,
        )
        .join("")}
    </div>
  `;
}

function renderHome() {
  const wrapper = document.getElementById("dynamic-readings-wrapper");
  if (!wrapper) return;
  
  const activeReadings = state.readings.filter(r => state.clubs.some(c => c.id === r.clubId && c.joined));
  
  wrapper.innerHTML = activeReadings.map(reading => {
    const book = state.bookMeta[reading.bookId] || { title: reading.title, author: reading.author, color: "purple" };
    return `
      <div class="card hero-card">
        <div class="card-header">
          <div>
            <span class="eyebrow">Current reading</span>
            <h3>${reading.title}</h3>
          </div>
          <span class="pill accent">${reading.progress}%</span>
        </div>
        <div class="book-row">
          <div class="book-cover cover-${book.color}">
            <span>${reading.title.split(',')[0]}</span>
            <strong>${reading.author}</strong>
          </div>
          <div class="card-body">
            <p class="muted">${reading.club}</p>
            <div class="meta">${reading.currentPage} / ${reading.totalPages} pages • ${reading.deadline}</div>
            <div class="progress"><div style="width:${reading.progress}%"></div></div>
            <div class="button-row">
              <button class="primary-btn" data-scroll="reading">Update progress</button>
              <button class="secondary-btn" data-scroll="clubs">View club</button>
            </div>
          </div>
        </div>
      </div>
    `;
  }).join('');
}

function applyNavigation() {
  document.querySelectorAll("[data-section]").forEach((button) => {
    button.classList.toggle("active", button.dataset.section === "home");
  });
}

function renderAll() {
  renderClubs();
  renderSelection();
  renderReadings();
  renderRanking();
  renderChallenges();
  renderRewards();
  renderNotifications();
  renderAchievements();
  renderCalendar();
  renderHome();
}

document.addEventListener("click", (event) => {
  const target = event.target.closest("[data-action]");
  if (!target) return;

  const { action, id, day, cost, book, index } = target.dataset;

  if (action === "toggle-join") {
    const club = state.clubs.find((item) => item.id === id);
    club.joined = !club.joined;
    renderAll();
  }

  if (action === "request-access") {
    alert("Your request has been queued for the club admin.");
  }

  if (action === "vote-book") {
    const club = state.selection[target.dataset.club];
    club.votes[Number(index)] += 1;
    state.points += 5;
    renderAll();
  }

  if (action === "reveal-draw") {
    const club = state.selection[target.dataset.club];
    club.selected = club.books[0];
    renderAll();
  }

  if (action === "advance-reading") {
    const reading = state.readings.find((item) => item.id === id);
    reading.progress = Math.min(100, reading.progress + 8);
    reading.currentPage = Math.min(reading.totalPages, reading.currentPage + 32);
    if (reading.progress >= 100) {
      state.notifications.unshift({ title: "Book completed", body: `${reading.title} is now complete.`, type: "achievement" });
      state.points += 100;
    } else {
      state.points += 20;
    }
    renderAll();
  }

  if (action === "complete-reading") {
    const reading = state.readings.find((item) => item.id === id);
    reading.progress = 100;
    reading.currentPage = reading.totalPages;
    state.points += 100;
    state.notifications.unshift({ title: "Book completed", body: `${reading.title} is now complete.`, type: "achievement" });
    renderAll();
  }

  if (action === "redeem-reward") {
    state.points -= Number(cost);
    renderRewards();
  }

  if (action === "reveal-spoiler") {
    alert("Spoiler revealed.");
  }

  if (action === "select-day") {
    state.selectedDay = Number(day);
    renderCalendar();
  }
});

document.addEventListener("click", (event) => {
  const tab = event.target.closest("[data-rank-tab]");
  if (!tab) return;
  state.rankTab = tab.dataset.rankTab;
  document.querySelectorAll("[data-rank-tab]").forEach((button) => button.classList.toggle("active", button === tab));
  renderRanking();
});

document.addEventListener("input", (event) => {
  if (event.target.id === "search") {
    state.search = event.target.value;
    renderClubs();
  }
});

document.addEventListener("click", (event) => {
  const button = event.target.closest("[data-scroll]");
  if (button) {
    document.querySelector(`[data-section-panel="${button.dataset.scroll}"]`)?.scrollIntoView({ behavior: "smooth" });
  }
});

document.querySelectorAll("[data-section]").forEach((button) => {
  button.addEventListener("click", () => {
    document.querySelectorAll("[data-section]").forEach((item) => item.classList.toggle("active", item === button));
    document.querySelector(`[data-section-panel="${button.dataset.section}"]`)?.scrollIntoView({ behavior: "smooth", block: "start" });
  });
});

el("#sign-in-btn").addEventListener("click", () => {
  state.points += 0;
  alert("Progress updates are ready.");
});

el("#open-reading").addEventListener("click", () => {
  document.querySelector('[data-section-panel="reading"]').scrollIntoView({ behavior: "smooth" });
});

renderAll();

const mockUsers = [
  { email: "bianca@example.com", password: "password123", name: "Bianca" },
  { email: "luna@example.com", password: "password123", name: "Luna" },
  { email: "clara@example.com", password: "password123", name: "Clara" },
  { email: "milo@example.com", password: "password123", name: "Milo" },
  { email: "sofia@example.com", password: "password123", name: "Sofia" }
];

function handleLogin() {
  const email = el("#login-email").value.trim();
  const password = el("#login-password").value;
  const errorEl = el("#login-error");
  
  if (!email || !password) {
    errorEl.textContent = "Please enter an email and password";
    return;
  }
  
  const user = mockUsers.find(u => u.email === email && u.password === password);
  
  if (user) {
    el("#login-overlay").style.display = "none";
    el("#app-shell").style.display = "flex"; 
    
    if (document.getElementById('welcome-text')) {
      document.getElementById('welcome-text').textContent = `Good morning, ${user.name}`;
    }
    if (document.getElementById('profile-name')) {
      document.getElementById('profile-name').textContent = user.name;
    }
    if (document.getElementById('profile-handle')) {
      document.getElementById('profile-handle').textContent = `@${user.name.toLowerCase()}`;
    }
  } else {
    errorEl.textContent = "Invalid email or password";
  }
}

const loginBtn = el("#login-btn");
if (loginBtn) {
  loginBtn.addEventListener("click", handleLogin);
}
