import 'dart:io';

void main() {
  final htmlFile = File('frontend-web/index.html');
  var htmlContent = htmlFile.readAsStringSync();
  
  htmlContent = htmlContent.replaceAll(
    '<span class="eyebrow">Good morning, Bianca</span>',
    '<span class="eyebrow" id="welcome-text">Good morning, LitApp Reader</span>'
  );

  htmlContent = htmlContent.replaceAll(
    '<h3>Bianca Vale</h3>',
    '<h3 id="profile-name">LitApp Reader</h3>'
  );

  htmlContent = htmlContent.replaceAll(
    '<p class="muted">@biancavale</p>',
    '<p class="muted" id="profile-handle">@reader</p>'
  );

  htmlFile.writeAsStringSync(htmlContent);

  final jsFile = File('frontend-web/app.js');
  var jsContent = jsFile.readAsStringSync();
  
  if (jsContent.contains('// Update hardcoded name in state optionally here')) {
    jsContent = jsContent.replaceFirst(
      '// Update hardcoded name in state optionally here if we showed user name, \n    // for this mock we just login successfully.',
      '''
    if (document.getElementById('welcome-text')) {
      document.getElementById('welcome-text').textContent = `Good morning, \${user.name}`;
    }
    if (document.getElementById('profile-name')) {
      document.getElementById('profile-name').textContent = user.name;
    }
    if (document.getElementById('profile-handle')) {
      document.getElementById('profile-handle').textContent = `@\${user.name.toLowerCase()}`;
    }
'''
    );
    jsFile.writeAsStringSync(jsContent);
  }
}
