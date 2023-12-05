<!DOCTYPE html>
<html lang="ru">
<head>
      <meta charset="utf-8">
      <title>Баголог / Регистрация</title>
</head>
<body>

      <cfparam name="form.username" default="">
      <cfparam name="form.password" default="">
      <cfparam name="form.email" default="">

      <cfif isDefined("form.submit")>
            <cfquery name="insertUser" datasource="ErrorHandler">
                  INSERT INTO users (login, password, email, role)
                  VALUES (
                        <cfqueryparam value="#form.login#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#hash(form.password, 'SHA-256')#" cfsqltype="CF_SQL_VARCHAR">,
                        <cfqueryparam value="#form.email#" cfsqltype="CF_SQL_VARCHAR">,
                        1
                  )
            </cfquery>
            <cflocation url="login.cfm" addtoken="false">
      </cfif>

      <h2>Registration</h2>

      <cfif isDefined("registrationMessage")>
            <p style="color: green;">#registrationMessage#</p>
      </cfif>

      <form method="post" action="#CGI.SCRIPT_NAME#">
            <label for="login">Username:</label>
            <input type="text" id="login" name="login" required>

            <br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <br>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" required>

            <br>

            <input type="submit" name="submit" value="Register">
      </form>

<body>
</html>