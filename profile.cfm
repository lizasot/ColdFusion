<cfinclude template="PageDraw.cfc">

<cfset profilePage = createObject("component", "PageDraw").init("Баголог / Профиль")>

<cffunction name="drawProfileById" access="public" returntype="string" hint="Profile page">
    <cfargument name="userId" type="integer" required="false">
    <cfquery name="getUser" datasource="ErrorHandler">
        SELECT id, login, role FROM users
        WHERE id = <cfqueryparam value="#userId#" cfsqltype="CF_SQL_INTEGER">
        LIMIT 1
    </cfquery>
    <cfset htmlContent = '<div class="profile-container">
        <h1>Профиль пользователя</h1>
        <table>
            <tr>
                <th>ID</th>
                <td>
    '>
    <cfset htmlContent &= #getUser.id#>
    <cfset htmlContent &= '</td>
            </tr>
            <tr>
                <th>Логин</th>
                <td>
    '>
    <cfset htmlContent &= #getUser.login#>
    <cfset htmlContent &= '</td>
            </tr>
            <tr>
                <th>Роль</th>
                <td>
    '>
    <cfset htmlContent &= #getUser.role#>
    <cfset htmlContent &= '</td>
            </tr>
        </table>
    </div>
    '>
    <cfreturn htmlContent>
</cffunction>
<cfif structKeyExists(cookie, "userID")>
    <cfoutput>#profilePage.drawPage(drawProfileById(cookie.userID))#</cfoutput>
</cfif>