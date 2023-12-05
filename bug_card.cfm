<cfinclude template="PageDraw.cfc">
<cfinclude template="enums.cfc">

<cfparam name="url.bugId" default="">

<cfset bugcardPage = createObject("component", "PageDraw").init("Баголог / Карточка ошибки")>

<cfif isDefined("form.submit")>
    <cfif #url.bugId# == -1>
        <cftry>
            <cfquery datasource="ErrorHandler">
                INSERT INTO error_info (date_input, sdescription, description, user, status, urgency, critical)
                VALUES (
                    <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">,
                    <cfqueryparam value="#form.sdescription#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#form.description#" cfsqltype="cf_sql_varchar">,
                    <cfqueryparam value="#cookie.userID#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#form.status#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#form.urgency#" cfsqltype="cf_sql_integer">,
                    <cfqueryparam value="#form.critical#" cfsqltype="cf_sql_integer">
                )
            </cfquery>
            <cfcatch>
                <p>Error during create</p>
                <cfoutput>
                    <p>Error Type: #cfcatch.type#</p>
                    <p>Error Message: #cfcatch.message#</p>
                    <p>Error Detail: #cfcatch.detail#</p>
                    <p>Tag Context: #cfcatch.tagContext#</p>
                </cfoutput>
            </cfcatch>
        </cftry>
    <cfelse>
        <cftry>
            <cfquery datasource="ErrorHandler">
                UPDATE error_info
                SET
                    date_input = <cfqueryparam value="#dateFormat(now(), 'yyyy-mm-dd')#" cfsqltype="cf_sql_date">,
                    sdescription = <cfqueryparam value="#form.sdescription#" cfsqltype="cf_sql_varchar">,
                    description = <cfqueryparam value="#form.description#" cfsqltype="cf_sql_varchar">,
                    status = <cfqueryparam value="#form.status#" cfsqltype="cf_sql_integer">,
                    urgency = <cfqueryparam value="#form.urgency#" cfsqltype="cf_sql_integer">,
                    critical = <cfqueryparam value="#form.critical#" cfsqltype="cf_sql_integer">
                WHERE id = <cfqueryparam value="#url.bugId#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfcatch>
                <p>Error during save</p>
                <cfoutput>
                    <p>Error Type: #cfcatch.type#</p>
                    <p>Error Message: #cfcatch.message#</p>
                    <p>Error Detail: #cfcatch.detail#</p>
                    <p>Tag Context: #cfcatch.tagContext#</p>
                </cfoutput>
            </cfcatch>
        </cftry>
    </cfif>
</cfif>

<cffunction name="fillCard" access="public" returntype="string">
    <cfargument name="sdescription" type="string" required="true">
    <cfargument name="description" type="string" required="true">
    <cfargument name="status" type="integer" required="true">
    <cfargument name="urgency" type="integer" required="true">
    <cfargument name="critical" type="integer" required="true">
    <cfset htmlContent = '<form method="post" action="bug_card.cfm?bugId='>
    <cfset htmlContent &= #url.bugId#>
    <cfset htmlContent &= '"><div class="form-group col-5">
    <label for="sdescription">sdescription:</label>
    <input class="form-control" type="text" id="sdescription" name="sdescription" value="'>
    <cfset htmlContent &= #sdescription#>
    <cfset htmlContent &= '" required></div>
    <div class="form-group col-5">
    <label for="description">description:</label>
    <textarea class="form-control" type="text" id="description" name="description" required>'>
    <cfset htmlContent &= #description#>
    <cfset htmlContent &= '</textarea></div>
    <div class="form-group col-5">
    <label for="status">status:</label>
    <select class="form-control" name="status" id="status-select" required>'>
        <cfloop array="#StatusEnum#" item="statusName" index="statusCode">
            <cfset htmlContent &= '<option value="'>
            <cfset htmlContent &= #statusCode#>
            <cfset htmlContent &= '"'>
            <cfif #status# == #statusCode#>
                <cfset htmlContent &= 'selected'>
            </cfif>
            <cfset htmlContent &= '>'>
            <cfset htmlContent &= #statusName#>
            <cfset htmlContent &= '</option>'>
        </cfloop>
    <cfset htmlContent &= '</select></div>
    <div class="form-group col-5">
    <label for="urgency">urgency:</label>
    <select class="form-control" name="urgency" id="urgency-select" required>'>
        <cfloop array="#UrgencyEnum#" item="urgencyName" index="urgencyCode">
            <cfset htmlContent &= '<option value="'>
            <cfset htmlContent &= #urgencyCode#>
            <cfset htmlContent &= '"'>
            <cfif #urgency# == #urgencyCode#>
                <cfset htmlContent &= 'selected'>
            </cfif>
            <cfset htmlContent &= '>'>
            <cfset htmlContent &= #urgencyName#>
            <cfset htmlContent &= '</option>'>
        </cfloop>
    <cfset htmlContent &= '</select></div>
    <div class="form-group col-5">
    <label for="critical">critical:</label>
    <select class="form-control" name="critical" id="critical-select" required>'>
        <cfloop array="#CriticalEnum#" item="criticalName" index="criticalCode">
            <cfset htmlContent &= '<option value="'>
            <cfset htmlContent &= #criticalCode#>
            <cfset htmlContent &= '"'>
            <cfif #critical# == #criticalCode#>
                <cfset htmlContent &= 'selected'>
            </cfif>
            <cfset htmlContent &= '>'>
            <cfset htmlContent &= #criticalName#>
            <cfset htmlContent &= '</option>'>
        </cfloop>
    <cfset htmlContent &= '</select></div>
    <input type="submit" name="submit" class="btn btn-success" value="Сохранить">
    </form>'>
    <cfreturn htmlContent>
</cffunction>

<cffunction name="drawBugCard" access="public" returntype="string" hint="Bug card page">
    <cfargument name="bugId" type="integer" required="true">
    <cfset htmlContent = '<div class="error-card-container">
        <h1>Карточка ошибки</h1>
    '>
    <cfif #bugId# == -1>
        <cfset htmlContent &= fillCard('', '', 1, 1, 1)>
    <cfelse>
        <cfquery name="getErrorById" datasource="ErrorHandler">
            SELECT * FROM error_info WHERE id = #bugId# LIMIT 1
        </cfquery>
        <cfset htmlContent &= '<p>ID: '>
        <cfset htmlContent &=#getErrorById.id#>
        <cfset htmlContent &= '</p><p>Last UPD: '>
        <cfset htmlContent &=#getErrorById.date_input#>
        <cfset htmlContent &= '</p><p>User creator: '>
        <cfset htmlContent &=#getErrorById.user#>
        <cfset htmlContent &= '</p>'>
        <cfset htmlContent &= fillCard(getErrorById.sdescription, getErrorById.description, Val(getErrorById.status), Val(getErrorById.urgency), Val(getErrorById.critical))>
    </cfif>
    <cfset htmlContent &= '
    </div>
    '>
    <cfreturn htmlContent>
</cffunction>
<cfoutput>#bugcardPage.drawPage(drawBugCard(Val(url.bugId)))#</cfoutput>