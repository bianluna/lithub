import 'dart:io';

void main() {
  final htmlFile = File('frontend-web/index.html');
  var htmlContent = htmlFile.readAsStringSync();
  
  htmlContent = htmlContent.replaceFirst(
    '<div class="app-shell">',
    '''
    <div id="login-overlay" class="login-overlay">
      <div class="login-card">
        <div class="brand">
          <div class="brand-mark">L</div>
          <div>
            <h1>LitApp</h1>
            <p>Welcome Back</p>
          </div>
        </div>
        <p class="login-subtitle">Log in to continue your reading journey.</p>
        <div class="input-group">
          <input type="email" id="login-email" placeholder="Email address" />
        </div>
        <div class="input-group">
          <input type="password" id="login-password" placeholder="Password" />
        </div>
        <div id="login-error" class="login-error"></div>
        <button id="login-btn" class="primary-btn">Log In</button>
      </div>
    </div>
    <div class="app-shell" id="app-shell" style="display: none;">'''
  );

  htmlFile.writeAsStringSync(htmlContent);
}
