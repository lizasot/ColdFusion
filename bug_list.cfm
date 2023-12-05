<cfinclude template="PageDraw.cfc">
<cfinclude template="enums.cfc">

<cfset buglistPage = createObject("component", "PageDraw").init("Баголог / Список ошибок")>

<cffunction name="drawBugList" access="public" returntype="string" hint="Profile page">
    <cfquery name="getErrorList" datasource="ErrorHandler">
        SELECT * FROM error_info
    </cfquery>
    <cfset htmlContent = '<div class="error-list-container">
        <h1>Список ошибок</h1>
        <table class="table table-striped">
            <tr>
                <th>ID</th>
                <th>Ошибка</th>
                <th>Статус</th>
                <th>Срочность</th>
                <th>Критичность</th>
                <th>Дата ввода</th>
                <th>Редактирование</th>
            </tr>
    '>
    <cfloop query="getErrorList">
        <cfset htmlContent &= '<tr><th>'>
        <cfset htmlContent &= getErrorList.id>
        <cfset htmlContent &= '</th><td>'>
        <cfset htmlContent &= getErrorList.sdescription>
        <cfset htmlContent &= '</td><td>'>
        <cfset htmlContent &= StatusEnum[getErrorList.status]>
        <cfset htmlContent &= '</td><td>'>
        <cfset htmlContent &= UrgencyEnum[getErrorList.urgency]>
        <cfset htmlContent &= '</td><td>'>
        <cfset htmlContent &= CriticalEnum[getErrorList.critical]>
        <cfset htmlContent &= '</td><td>'>
        <cfset htmlContent &= getErrorList.date_input>
        <cfset htmlContent &= '</td><td><a class="btn btn-primary" href="bug_card.cfm?bugId='>
        <cfset htmlContent &= getErrorList.id>
        <cfset htmlContent &= '">Редактировать</a></td></tr>'>
    </cfloop>
    <cfset htmlContent &= '
        </table>
    </div>
    '>
    <cfreturn htmlContent>
</cffunction>
<cfoutput>#buglistPage.drawPage(drawBugList())#</cfoutput>