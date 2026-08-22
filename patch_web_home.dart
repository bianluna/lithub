import 'dart:io';

void main() {
  final htmlFile = File('frontend-web/index.html');
  var htmlContent = htmlFile.readAsStringSync();
  
  // Replace the hardcoded current reading card.
  final startIndex = htmlContent.indexOf('<div class="card hero-card">\\n            <div class="card-header">\\n              <div>\\n                <span class="eyebrow">Current reading</span>');
  
  if (htmlContent.contains('<span class="eyebrow">Current reading</span>')) {
     final oldBlock = '''          <div class="card hero-card">
            <div class="card-header">
              <div>
                <span class="eyebrow">Current reading</span>
                <h3>Tomorrow, and Tomorrow, and Tomorrow</h3>
              </div>
              <span class="pill accent">67%</span>
            </div>
            <div class="book-row">
              <div class="book-cover cover-purple">
                <span>Tomorrow</span>
                <strong>Gabrielle Zevin</strong>
              </div>
              <div class="card-body">
                <p class="muted">Lithappened</p>
                <div class="meta">268 / 400 pages • 12 days remaining</div>
                <div class="progress"><div style="width:67%"></div></div>
                <div class="button-row">
                  <button class="primary-btn" id="open-reading">Update progress</button>
                  <button class="secondary-btn" data-scroll="clubs">View club</button>
                </div>
              </div>
            </div>
          </div>''';
     
     htmlContent = htmlContent.replaceFirst(oldBlock, '<div id="dynamic-readings-wrapper" style="display: contents;"></div>');
     htmlFile.writeAsStringSync(htmlContent);
  }

  // Update app.js renderHome function
  final jsFile = File('frontend-web/app.js');
  var jsContent = jsFile.readAsStringSync();
  
  final jsOld = '''function renderHome() {
  // Intentionally keeps the homepage cards static; the visible data stays in sync with other sections.
}''';

  final jsNew = '''function renderHome() {
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
            <h3>\${reading.title}</h3>
          </div>
          <span class="pill accent">\${reading.progress}%</span>
        </div>
        <div class="book-row">
          <div class="book-cover cover-\${book.color}">
            <span>\${reading.title.split(',')[0]}</span>
            <strong>\${reading.author}</strong>
          </div>
          <div class="card-body">
            <p class="muted">\${reading.club}</p>
            <div class="meta">\${reading.currentPage} / \${reading.totalPages} pages • \${reading.deadline}</div>
            <div class="progress"><div style="width:\${reading.progress}%"></div></div>
            <div class="button-row">
              <button class="primary-btn" data-scroll="reading">Update progress</button>
              <button class="secondary-btn" data-scroll="clubs">View club</button>
            </div>
          </div>
        </div>
      </div>
    `;
  }).join('');
}''';
  
  if (jsContent.contains(jsOld)) {
     jsContent = jsContent.replaceFirst(jsOld, jsNew);
     jsFile.writeAsStringSync(jsContent);
  } else {
     print("Could not find jsOld");
  }
}
