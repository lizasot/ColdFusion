<!DOCTYPE html>
<html lang="ru">
<head>
      <meta charset="utf-8">
      <title>Баголог / Аутентификация</title>
</head>
<body>
      <cfparam name="form.login" default="">
      <cfparam name="form.password" default="">
      <cfif not structKeyExists(cookie, "userID")>
            <cflocation url="login.cfm" addtoken="false">
      </cfif>

      <cfif isDefined("form.submit")>
            <cftry>
                  <cfset StructDelete(cookie,"userID")>
                  <cfset StructDelete(cookie,"userLogin")>
                  <cfset StructDelete(cookie,"userRole")>
                  <cflocation url="login.cfm" addtoken="false">
                  <cfcatch>
                        <p>Error during logout</p>
                  </cfcatch>
            </cftry>
      </cfif>

      <h2>Logout</h2>
      <p>Are you sure you want to log out?</p>
      <form method="post" action="#CGI.SCRIPT_NAME#">
            <input type="submit" name="submit" value="Logout">
      </form>

<body>
</html>