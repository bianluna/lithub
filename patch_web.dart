import 'dart:io';

void main() {
  final htmlFile = File('frontend-web/index.html');
  var htmlContent = htmlFile.readAsStringSync();
  
  if (!htmlContent.contains('id="login-overlay"')) {
    htmlContent = htmlContent.replaceFirst(
      '<body>',
      '''<body>
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
    // Find the last closing div for app-shell
    htmlContent = htmlContent.replaceFirst(
      '    </div>\n    <script',
      '      </div>\n    </div>\n    <script'
    );
    htmlFile.writeAsStringSync(htmlContent);
  }

  final cssFile = File('frontend-web/styles.css');
  var cssContent = cssFile.readAsStringSync();
  if (!cssContent.contains('.login-overlay')) {
    cssContent += '''

/* Login Screen Styles */
.login-overlay {
  position: fixed;
  top: 0;
  left: 0;
  right: 0;
  bottom: 0;
  background-color: var(--surface-warm);
  display: flex;
  align-items: center;
  justify-content: center;
  z-index: 1000;
}

.login-card {
  background: white;
  padding: 40px;
  border-radius: var(--radius);
  box-shadow: var(--shadow);
  width: 100%;
  max-width: 400px;
  display: flex;
  flex-direction: column;
  gap: 20px;
  align-items: center;
}

.login-card .brand {
  margin-bottom: 20px;
  justify-content: center;
}

.login-subtitle {
  color: var(--text-muted);
  text-align: center;
}

.login-card .input-group {
  width: 100%;
}

.login-card input {
  width: 100%;
  padding: 12px 16px;
  border: 1px solid #ddd;
  border-radius: var(--radius);
  font-family: inherit;
  font-size: 1rem;
}

.login-card .primary-btn {
  width: 100%;
  padding: 12px;
  font-size: 1rem;
}

.login-error {
  color: #e57373;
  font-size: 0.9rem;
  min-height: 20px;
}
''';
    cssFile.writeAsStringSync(cssContent);
  }

  final jsFile = File('frontend-web/app.js');
  var jsContent = jsFile.readAsStringSync();
  
  if (!jsContent.contains('function handleLogin(')) {
    // Add logic at the end or near the listeners
    jsContent = jsContent.replaceFirst(
      'document.addEventListener("DOMContentLoaded", () => {',
      '''
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
    el("#app-shell").style.display = "flex"; // Show app layout
    // Update hardcoded name in state optionally here if we showed user name, 
    // for this mock we just login successfully.
  } else {
    errorEl.textContent = "Invalid email or password";
  }
}

document.addEventListener("DOMContentLoaded", () => {
  const loginBtn = el("#login-btn");
  if (loginBtn) {
    loginBtn.addEventListener("click", handleLogin);
  }
'''
    );
    
    jsFile.writeAsStringSync(jsContent);
  }
}
