<!DOCTYPE html>
<html lang="ru">
<head>
      <meta charset="utf-8">
      <meta name="viewport" content="width=device-width, initial-scale=1.0">
      <title>Баголог / Аутентификация</title>
</head>
<body>
      <cfparam name="form.login" default="">
      <cfparam name="form.password" default="">
      <cfset mainPageUrl = "profile.cfm">

      <cfif structKeyExists(cookie, "userID")>
            <cflocation url="#mainPageUrl#" addtoken="false">
      </cfif>

      <cfif isDefined("form.submit")>
            <cftry>
                  <cfquery name="getUser" datasource="ErrorHandler">
                        SELECT id, login, role FROM users
                        WHERE login = <cfqueryparam value="#form.login#" cfsqltype="CF_SQL_VARCHAR">
                        AND password = <cfqueryparam value="#hash(form.password, 'SHA-256')#" cfsqltype="CF_SQL_VARCHAR">
                  </cfquery>

                  <cfif getUser.recordCount>
                        <cfset cookie.userID = getUser.id>
                        <cfset cookie.userLogin = getUser.login>
                        <cfset cookie.userRole = getUser.role>
                        <cflocation url="#mainPageUrl#" addtoken="false">
                  <cfelse>
                        <cfset errorMessage = "Invalid username or password.">
                  </cfif>
                  <cfcatch>
                        <p>Error during login</p>
                  </cfcatch>
            </cftry>
      </cfif>

      <h2>Login</h2>

      <cfif isDefined("errorMessage")>
            <cfoutput><p style="color: red;">#errorMessage#</p></cfoutput>
      </cfif>

      <form method="post" action="#CGI.SCRIPT_NAME#">
            <label for="login">login:</label>
            <input type="text" id="login" name="login" required>

            <br>

            <label for="password">Password:</label>
            <input type="password" id="password" name="password" required>

            <br>

            <input type="submit" name="submit" value="Login">
      </form>

<body>
</html>