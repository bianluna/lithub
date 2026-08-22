import 'dart:io';

void main() {
  final jsFile = File('frontend-web/app.js');
  var jsContent = jsFile.readAsStringSync();
  
  final jsOld = '''document.querySelectorAll("[data-scroll]").forEach((button) => {
  button.addEventListener("click", () => {
    document.querySelector(`[data-section-panel="\${button.dataset.scroll}"]`)?.scrollIntoView({ behavior: "smooth" });
  });
});''';

  final jsNew = '''document.addEventListener("click", (event) => {
  const button = event.target.closest("[data-scroll]");
  if (button) {
    document.querySelector(`[data-section-panel="\${button.dataset.scroll}"]`)?.scrollIntoView({ behavior: "smooth" });
  }
});''';
  
  if (jsContent.contains(jsOld)) {
     jsContent = jsContent.replaceFirst(jsOld, jsNew);
     jsFile.writeAsStringSync(jsContent);
  } else {
     print("Could not find jsOld");
  }
}
