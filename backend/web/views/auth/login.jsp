<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>AutoWash Pro - Sign In</title>
        <link rel="stylesheet" type="text/css" href="${pageContext.request.contextPath}/assets/css/pages/login.css">
    </head>
    <body>
        
        <div class="login-card">
            <h2>Welcome Back</h2>
            <p class="subtitle">Sign in to manage your vehicle fleet</p>

            <%
                String errorMsg = (String) request.getAttribute("ERROR_MSG");
                String showClass = (errorMsg != null) ? "show" : "";
            %>

            <div id="errorAlert" class="error-alert <%= showClass %>">
                <svg class="error-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                    <circle cx="12" cy="12" r="10"></circle>
                    <line x1="12" y1="8" x2="12" y2="12"></line>
                    <line x1="12" y1="16" x2="12.01" y2="16"></line>
                </svg>
                <span id="errorText" class="error-text">
                    <%= (errorMsg != null) ? errorMsg : "Email hoặc mật khẩu không chính xác." %>
                </span>
            </div>

            <form class="login-form" action="login" method="POST">
                
                <div class="input-group">
                    <label for="email">Email Address</label>
                    <div class="input-wrapper">
                        <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <path d="M4 4h16c1.1 0 2 .9 2 2v12c0 1.1-.9 2-2 2H4c-1.1 0-2-.9-2-2V6c0-1.1.9-2 2-2z"></path>
                            <polyline points="22,6 12,13 2,6"></polyline>
                        </svg>
                        <input type="email" id="email" name="txtEmail" placeholder="example@domain.com" required autocomplete="email">
                    </div>
                </div>

                <div class="input-group">
                    <label for="password">Password</label>
                    <div class="input-wrapper">
                        <svg class="input-icon" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                            <rect x="3" y="11" width="18" height="11" rx="2" ry="2"></rect>
                            <path d="M7 11V7a5 5 0 0 1 10 0v4"></path>
                        </svg>
                        <input type="password" id="password" name="txtPassword" placeholder="••••••••" required>
                    </div>
                </div>

                <div class="form-options">
                    <label class="remember-me">
                        <input type="checkbox" name="chkRemember"> 
                        <span>Remember Me</span>
                    </label>
                    <a href="#" class="forgot-pass">Forgot Password?</a>
                </div>

                <button type="submit" class="btn-signin">
                    <span>Sign In</span>
                    <svg class="btn-arrow" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2.5">
                        <line x1="5" y1="12" x2="19" y2="12"></line>
                        <polyline points="12 5 19 12 12 19"></polyline>
                    </svg>
                </button>
            </form>

            <div class="card-footer">
                Don't have an account? <a href="register.jsp" class="create-account">Create Account</a>
            </div>
        </div>

        <script>
            const emailInput = document.getElementById('email');
            const passwordInput = document.getElementById('password');
            const errorAlert = document.getElementById('errorAlert');

            function hideError() {
                if (errorAlert.classList.contains('show')) {
                    errorAlert.classList.remove('show');
                }
            }
            emailInput.addEventListener('input', hideError);
            passwordInput.addEventListener('input', hideError);
        </script>

    </body>
</html>