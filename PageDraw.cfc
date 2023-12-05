<cfcomponent displayname="PageDraw" output="false">
    <cfproperty name="title" type="string" default="Баголог">
    <cfset variables.menu = [
        {
            "url": "profile.cfm",
            "name": "Профиль"
        },
        {
            "url": "bug_list.cfm",
            "name": "Список ошибок"
        },
        {
            "url": "bug_card.cfm?bugId=-1",
            "name": "Создание новой ошибки"
        },
        {
            "url": "logout.cfm",
            "name": "Выход"
        }
    ]
    />
    <!-- constructor method -->
    <cffunction name="init" access="public" returntype="PageDraw">
        <cfargument name="newTitle" type="string" default="Баголог">

        <cfset variables.title = newTitle>

        <cfreturn this>
    </cffunction>

    <cffunction name="setTitle" access="public" returntype="void" hint="Set the title property">
        <cfargument name="newTitle" type="string" required="true">
        <cfset variables.title = arguments.newTitle>
    </cffunction>

    <cffunction name="drawPage" access="public" returntype="string" hint="Display information">
        <cfargument name="fileContent" type="string" required="true" hint="HTML content">
        <cfif not structKeyExists(cookie, "userID")>
            <cflocation url="login.cfm" addtoken="false">
        </cfif>
        <cfset var htmlContent = '
            <!DOCTYPE html>
            <html lang="ru">
            <head>
                <meta charset="UTF-8">
                <title>#variables.title#</title>
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
                <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap-theme.min.css">
                <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
                <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
            </head>
            <body>
            <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
                <div class="collapse navbar-collapse" id="container">
                    <ul class="nav">
        ' />
        <cfloop array="#variables.menu#" index="item">
            <cfset htmlContent &= '<li class="nav-item"><a class="navbar-brand" href="'>
            <cfset htmlContent &= #item.url#>
            <cfset htmlContent &= '">'>
            <cfset htmlContent &= #item.name#>
            <cfset htmlContent &= '</a>'>
        </cfloop>
        <cfset htmlContent &= '</div></nav>
                    <div id="main-content">
                        #fileContent#
                    </div>
                </div>
            </body>
            </html>
        ' />
        <cfreturn htmlContent>
    </cffunction>
</cfcomponent>