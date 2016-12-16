<cfcomponent displayname="RetroTax" output="false" accessors="true">


   <cffunction name="init" access="public" output="false" returntype="RetroTax">
      <cfargument name="username" type="string" required="false" default=""/>
      <cfargument name="password" type="string" required="false" default=""/>
      <cfargument name="apiUrl" type="string" required="false" default="http://api-sni.retrotax-aci.com"/>
      <cfargument name="apiVersion" type="string" required="false" default=""/>
      <cfargument name="key" type="string" required="true" default=""/>
      <cfargument name="defaultOccupationId" type="string" required="false" default=""/>
      <cfargument name="defaultStartingWage" type="string" required="false" default=""/>
      <cfargument name="hiringManagerName" type="string" required="false" default=""/>
      <cfargument name="hiringManagerTitle" type="string" required="false" default="Hiring Manager"/>
      <cfargument name="authToken" type="string" required="false" default=""/>
      <cfscript>
         variables.applicationName     = "RetroTax";
         variables.username            = arguments.username;
         variables.password            = arguments.password;
         variables.key                 = arguments.key;
         variables.apiUrl              = arguments.apiUrl;
         variables.apiVersion          = arguments.apiVersion;
         variables.accessLevel         = "";
         variables.authToken           = arguments.authToken;
         variables.defaultStartingWage = arguments.defaultStartingWage;
         variables.defaultOccupationId = arguments.defaultOccupationId;
         variables.hiringManagerName   = arguments.hiringManagerName;
         variables.hiringManagerTitle  = arguments.hiringManagerTitle;
      </cfscript>
      <cfreturn this />
   </cffunction>


   <cffunction name="setCredentials" access="public" output="false" returntype="any" hint="Sets values for credential variables needed to send a signin request. Only necessary if no arguments were supplied when initializing the RetroTax component.">
      <cfargument name="username" type="string" required="false" />
      <cfargument name="password" type="string" required="false" />
      <cfargument name="key" type="string" required="false" />
      <cfargument name="authToken" type="string" required="false" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfif isDefined("arguments.username") and arguments.username neq "">
            <cfset variables.username=arguments.username>
         </cfif>
         <cfif isDefined("arguments.password") and arguments.password neq "">
            <cfset variables.password=arguments.password>
         </cfif>
         <cfif isDefined("arguments.key") and arguments.key neq "">
            <cfset variables.key=arguments.key>
         </cfif>
         <cfif isDefined("arguments.authToken") and arguments.authToken neq "">
            <cfset variables.authToken=arguments.authToken>
         </cfif>
        <cfset local.results = true />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="signIn" access="public" output="false" returntype="any" hint="Returns an Authorization Token to be used for API calls.">
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/authentication" result="result" method="POST"  timeout="450"> 
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#">    
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type='body' value='{"username":"#variables.username#","password":"#variables.password#"}'> 
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="signOut" access="public" output="false" returntype="any" hint="Deletes this user's oauthToken from the RetroTax API. A sign in request will be required before making any more API calls.">
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/authentication" result="result" method="DELETE"  timeout="450"> 
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#">    
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="postEmployee" access="public" output="false" returntype="any" hint="Save an employee record">
      <cfargument name="params" type="string" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees" result="result" method="POST"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="header" name="accept" value="application/json"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="body" value="#arguments.params#">               
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getLocations" access="public" output="false" returntype="any" hint="Returns locations by their company ID" charset="utf-8">
      <cfargument name="companyId" type="string" required="true"/>
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/companies/#arguments.companyId#/locations" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#">    
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfif arguments.flushCache>
               <cfhttpparam type="header" name="Cache-Control" value="max-age:0">
            </cfif>   
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


  <cffunction name="getLocation" access="public" output="false" returntype="any" hint="Returns location by its company ID" charset="utf-8">
      <cfargument name="companyId" type="string" required="true" />
      <cfargument name="locationId" type="string" required="true" />
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/companies/#companyId#/locations/#locationId#" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">     
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfif arguments.flushCache>
               <cfhttpparam type="header" name="Cache-Control" value="max-age:0">
            </cfif>   
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getEmployees" access="public" output="false" returntype="any" hint="Returns employees" charset="utf-8">
      <cfargument name="locationId" type="string" required="false" default=""/>
      <cfargument name="status" type="string" required="false" default=""/>
      <cfargument name="search" type="string" required="false" default=""/>
      <cfargument name="page" type="string" required="false" default=""/>
      <cfargument name="per_page" type="string" required="false" default=""/>
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
    <!---  <cfif locationId eq 0><cfset locationId=""></cfif> --->
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees?location_id=#arguments.locationId#&status=#arguments.status#&search=#arguments.search#&page=#arguments.page#&per_page=#arguments.per_page#" result="result" method="GET"  timeout="850">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#">
            <cfif flushCache>
               <cfhttpparam type="header" name="Cache-Control" value="max-age:0">
            </cfif>  
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getEmployee" access="public" output="false" returntype="any" hint="Returns employee information by its ID">
      <cfargument name="employeeId" type="string" required="true" />
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfif arguments.flushCache>
               <cfhttpparam type="header" name="Cache-Control" value="max-age:0">
            </cfif>  
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


  <cffunction name="deleteEmployee" access="public" output="false" returntype="any" hint="Deletes an employee by its ID">
      <cfargument name="employeeId" type="string" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#" result="result" method="DELETE"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


  <cffunction name="updateEmployee" access="public" output="false" returntype="any" hint="Updates an employee by its ID">
      <cfargument name="employeeId" type="string" required="true" />
      <cfargument name="params" type="string" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#" result="result" method="PUT"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="body" value="#arguments.params#">                             
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


  <cffunction name="getDocuments" access="public" output="false" returntype="any" hint="Gets employee's documents by its ID">
      <cfargument name="employeeId" type="string" required="true" />
      <cfargument name="status" type="string" required="false" default=""/>
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#/documents?status=#arguments.status#" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfif arguments.flushCache>
               <cfhttpparam type="header" name="Cache-Control" value="max-age:0">
            </cfif> 
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>




  <cffunction name="postDocuments" access="public" output="false" returntype="any" hint="Inserts employee's documents" multipart="yes">
      <cfargument name="employeeId" type="string" required="true" />
      <cfargument name="documentCode" type="string" required="true" />
      <cfargument name="documentMimeType" type="string" required="true"/>
      <cfargument name="filePath" type="string" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cffile action="readBinary" file="#arguments.filePath#" variable="binaryObject">
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#/documents" result="result" method="POST"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="formfield" name="document_code" value="#arguments.documentCode#">  
            <cfhttpparam type="formfield" name="document_type" value="#arguments.documentMimeType#">  
            <cfhttpparam type="formfield" name="contents" value="#ToBase64(binaryObject)#">     
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getStates" access="public" output="false" returntype="any" hint="Returns a list of all states and territories and their two letter abbreviations.">
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/states" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfif flushCache>
               <cfhttpparam type="header" name="Cache-Control" value="max-age:0">
            </cfif>               
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getCounties" access="public" output="false" returntype="any" hint="Returns a list of counties by two letter state abbreviation.">
      <cfargument name="stateCode" type="string" required="true"/>
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/states/#arguments.stateCode#/counties" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="header" name="accept" value="application/json"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfif arguments.flushCache>
               <cfhttpparam type="header" name="Cache-Control" value="max-age:0">
            </cfif> 
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getCompanies" access="public" output="false" returntype="any" hint="Returns a list of companies related to the user">
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/companies" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfif arguments.flushCache>
               <cfhttpparam type="header" name="Cache-Control" value="max-age:0">
            </cfif>               
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getCompany" access="public" output="false" returntype="any" hint="Returns a company by its ID">
      <cfargument name="companyId" type="string" required="true" />
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/companies/#arguments.companyId#" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getOccupations" access="public" output="false" returntype="any" hint="Returns occupations">
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/occupations" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="header" name="accept" value="application/json"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


  <cffunction name="getBranches" access="public" output="false" returntype="any" hint="Returns branches">
      <cfargument name="flushCache" type="boolean" required="false" default="false"/>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/branches" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="header" name="accept" value="application/json"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


  <cffunction name="eSign" access="public" output="false" returntype="any" hint="Esigns an employee record">
      <cfargument name="employeeId" type="string" required="true" />
      <cfargument name="hiringManagerName" type="string" required="false" default="Angie Mackey"/>
      <cfargument name="hiringManagerTitle" type="string" required="false" default="Hiring Manager"/>
      <cfset params='{"authorization":true,"esign":true,"name":"#hiringManagerName#","title":"#hiringManagerTitle#"}'>
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#/esign" result="result" method="PUT"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="body" value="#params#">                             
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="updatePayEntry" access="public" output="false" returntype="any" hint="Updates payroll record">
      <cfargument name="employeeId" type="string" required="true" />
      <cfargument name="payEntry" type="string" required="true" />
      <cfargument name="wages" type="string" required="true" />
      <cfargument name="hours" type="string" required="true" />
      <cfargument name="end_date" type="string" required="true" />
      <cfargument name="start_date" type="string" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#/pay_entries/#arguments.payEntry#" result="result" method="PUT"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="body" value='{"wages":#Int(arguments.wages)#,"hours":#Int(arguments.hours)#,"end_date":"#arguments.end_date#","start_date":"#arguments.start_date#"}'>                             
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="deletePayEntry" access="public" output="false" returntype="any" hint="Deletes payroll record">
      <cfargument name="employeeId" type="string" required="true" />
      <cfargument name="payEntry" type="string" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#/pay_entries/#arguments.payEntry#" result="result" method="DELETE"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getPayEntries" access="public" output="false" returntype="any" hint="Get payroll entries">
      <cfargument name="employeeId" type="string" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#/pay_entries/" result="result" method="GET"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="postPayEntry" access="public" output="false" returntype="any" hint="Creates a payroll entry for an employee">
      <cfargument name="employeeId" type="string" required="true" />
      <cfargument name="wages" type="string" required="true" />
      <cfargument name="hours" type="string" required="true" />
      <cfargument name="end_date" type="string" required="true" />
      <cfargument name="start_date" type="string" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfhttp url="#variables.apiUrl##variables.apiVersion#/employees/#arguments.employeeId#/pay_entries" result="result" method="POST"  timeout="450">    
            <cfhttpparam type="header" name="X-VERSION" value="#variables.apiVersion#">    
            <cfhttpparam type="header" name="X-API-KEY" value="#variables.key#"> 
            <cfhttpparam type="header" name="Content-Type" value="application/json" />
            <cfhttpparam type="header" name="accept" value="application/json">               
            <cfhttpparam type="header" name="X-AUTH-TOKEN" value="#variables.authToken#"> 
            <cfhttpparam type="body" value='{"wages":#Int(arguments.wages)#,"hours":#Int(arguments.hours)#,"end_date":"#arguments.end_date#","start_date":"#arguments.start_date#"}'>                             
         </cfhttp> 
         <cfset local.results = result />
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cffunction name="getEmployeeInfoStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var employee_info={};
         employee_info['first_name']='';
         employee_info['last_name']='';
         employee_info['suffix']='';
         employee_info['dob']='';
         employee_info['zip']='';
         employee_info['city']='';
         employee_info['state']='';
         employee_info['county']='';
         employee_info['address_line_1']='';
         employee_info['address_line_2']='';
         employee_info['location_id']='';
         employee_info['ssn']='';
         employee_info['rehire']=false;
         return employee_info;
      </cfscript>   
   </cffunction>


    <cffunction name="getHiringManagerInfoStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var hiring_manager_info={};
         hiring_manager_info['occupation_id']=variables.defaultOccupationId;
         hiring_manager_info['dojo']=DateFormat(now(),"yyyy-mm-dd");
         hiring_manager_info['doh']=DateFormat(now(),"yyyy-mm-dd");
         hiring_manager_info['dsw']=DateFormat(now(),"yyyy-mm-dd");
         hiring_manager_info['dgi']=DateFormat(now(),"yyyy-mm-dd");
         hiring_manager_info['starting_wage']=variables.defaultStartingWage;
         return hiring_manager_info;
      </cfscript>   
   </cffunction>


    <cffunction name="getAfdcRecipientInfoStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var afdc_recipient_info={};
         afdc_recipient_info['name']='';
         afdc_recipient_info['relationship']='';
         afdc_recipient_info['county_received']='';
         afdc_recipient_info['state_received']='';
         afdc_recipient_info['city_received']='';
         return afdc_recipient_info;
      </cfscript>   
   </cffunction>


    <cffunction name="getBenefitsRecipientInfoStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var foodstamps_recipient_info={};
         foodstamps_recipient_info['name']='';
         foodstamps_recipient_info['relationship']='';
         foodstamps_recipient_info['county_received']='';
         foodstamps_recipient_info['state_received']='';
         foodstamps_recipient_info['city_received']='';
         return foodstamps_recipient_info;
      </cfscript>   
   </cffunction>


    <cffunction name="getVeteranInfoStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var veteran_info={};
         veteran_info['disabled']='false';
         veteran_info['service_start']='';
         veteran_info['service_stop']='';
         veteran_info['branch']='Army';
         return veteran_info;
      </cfscript>   
   </cffunction>


    <cffunction name="getUnemploymentInfoStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var unemployment_info={};
         unemployment_info['compensation_start_date']='';
         unemployment_info['compensated']='false';
         unemployment_info['compensation_stop_date']='';
         unemployment_info['unemployment_stop_date']='';
         unemployment_info['unemployment_start_date']='';
         return unemployment_info;
      </cfscript>   
   </cffunction>


   <cffunction name="getFelonInfoStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var felon_info={};
         felon_info['is_federal_conviction']='';
         felon_info['conviction_date']='';
         felon_info['parole_officer_phone']='';
         felon_info['parole_officer_name']='';
         felon_info['is_state_conviction']='';
         felon_info['release_date']='';
         felon_info['felony_state']='';
         felon_info['felony_county']='';
         return felon_info;
      </cfscript>   
   </cffunction>


   <cffunction name="getVocRehabInfoStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var voc_rehab_info={};
         voc_rehab_info['agency_name']='';
         voc_rehab_info['is_agency']='';
         voc_rehab_info['zip']='';
         voc_rehab_info['phone']='';
         voc_rehab_info['city']='';
         voc_rehab_info['state']='';
         voc_rehab_info['address_line_1']='';
         voc_rehab_info['address_line_2']='';
         voc_rehab_info['state']='';
         voc_rehab_info['dept_va']='';
         voc_rehab_info['county']='';
         return voc_rehab_info;
      </cfscript>   
   </cffunction>


   <cffunction name="getSignatureStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var e_signatures={};
         var hm_signature={};
         var emp_signature={};
         hm_signature['name']=variables.hiringManagerName;
         hm_signature['title']=variables.hiringManagerTitle;
         hm_signature['esign']=true;
         hm_signature['authorization']=true;
         emp_signature['esign']=true;
         emp_signature['authorization']=true;
         e_signatures['hm_signature']=hm_signature;
         e_signatures['emp_signature']=emp_signature;
         return e_signatures;
      </cfscript>   
   </cffunction>


   <cffunction name="getQuestionnaireStruct" access="public" output="false" returntype="struct" hint="">
      <cfargument name="ca_wia" type="boolean" required="false" default=false/>
      <cfargument name="sc_fib" type="boolean" required="false" default=false/>
      <cfargument name="ca_farmer" type="boolean" required="false" default=false/>
      <cfargument name="cdib" type="boolean" required="false" default=false/>
      <cfargument name="veteran" type="boolean" required="false" default=false/>
      <cfargument name="ca_cal_works" type="boolean" required="false" default=false/>
      <cfargument name="afdc" type="boolean" required="false" default=false/>
      <cfargument name="voc_rehab" type="boolean" required="false" default=false/>
      <cfargument name="ssi" type="boolean" required="false" default=false/>
      <cfargument name="food_stamps" type="boolean" required="false" default=false/>
      <cfargument name="felon" type="boolean" required="false" default=false/>
      <cfargument name="ca_misdemeanor" type="boolean" required="false" default=false/>
      <cfargument name="ca_foster" type="boolean" required="false" default=false/>
      <cfargument name="unemployed" type="boolean" required="false" default=false/>


      <cfscript>
         var questionnaire={};
         questionnaire['ca_wia']=arguments.ca_wia;
         questionnaire['sc_fib']=arguments.sc_fib;
         questionnaire['unemployed']=arguments.unemployed;
         questionnaire['ca_farmer']=arguments.ca_farmer;
         questionnaire['cdib']=arguments.cdib;
         questionnaire['veteran']=arguments.veteran;
         questionnaire['ca_cal_works']=arguments.ca_cal_works;
         questionnaire['afdc']=arguments.afdc;
         questionnaire['voc_rehab']=arguments.voc_rehab;
         questionnaire['ssi']=arguments.ssi;
         questionnaire['food_stamps']=arguments.food_stamps;
         questionnaire['felon']=arguments.felon;
         questionnaire['ca_misdemeanor']=arguments.ca_misdemeanor;
         questionnaire['ca_foster']=arguments.ca_foster;
         return questionnaire;
      </cfscript>   
   </cffunction>


    <cffunction name="getRetroTaxStruct" access="public" output="false" returntype="struct" hint="">
      <cfscript>
         var rt={};
         rt['hiring_manager_info']=getHiringManagerInfoStruct();
         rt['employee_info']=getEmployeeInfoStruct();
         rt['foodstamps_recipient_info']=getBenefitsRecipientInfoStruct();
         rt['veteran_info']=getVeteranInfoStruct();
         rt['unemployment_info']=getUnemploymentInfoStruct();
         rt['felon_info']=getFelonInfoStruct();
         rt['foodstamps_recipient_info']=getBenefitsRecipientInfoStruct();
         rt['afdc_recipient_info']=getAfdcRecipientInfoStruct();
         rt['voc_rehab_info']=getVocRehabInfoStruct();
         rt['questionnaire']=getQuestionnaireStruct();
         rt['e_signatures']=getSignatureStruct();
         return rt;
      </cfscript>   
   </cffunction>


   <cffunction name="createTestEmployee" access="public" output="false" returntype="any" hint="Returns test employee">
      <cfscript>
      var ssn=RandRange(111111111,999999999).toString();
      var occupationId=17;
return {
   "employee_info": {
      "first_name": "ColdFusion",
      "last_name": "Test",
      "address_line_1": "850 N Miami Ave",
      "address_line_2": "",
      "city": "Miami",
      "state": "FL",
      "zip": "33136",
      "ssn": ssn,
      "dob": "1987-01-01",
      "rehire": false,
      "location_id": 5463
   },
   "foodstamps_recipient_info": {
      "name": "foo",
      "relationship": "foo",
      "county_received": "foo",
      "state_received": "foo",
      "city_received": "foo"
   },
   "veteran_info": {
      "service_start": "2000-01-01",
      "disabled": true,
      "branch": "Army",
      "service_stop": "2000-02-01"
   },
   "unemployment_info": {
      "compensation_start_date": "2000-01-01",
      "compensated": true,
      "compensation_stop_date": "2000-02-01",
      "unemployment_start_date": "2001-01-01",
      "unemployment_stop_date": "2002-01-01"
   },
   "felon_info": {
      "is_federal_conviction": true,
      "conviction_date": "2010-01-01",
      "parole_officer_phone": "foo",
      "is_state_conviction": true,
      "parole_officer_name": "foo",
      "release_date": "2011-01-01",
      "felony_state":"IN",
      "felony_county":"Marion"


   },
   "voc_rehab_info": {
      "agency_name": "foo",
      "is_agency": true,
      "zip": "90210",
      "phone": "foo",
      "city": "foo",
      "dept_va": true,
      "county": "foo",
      "state": "foo",
      "address_1": "foo",
      "ttw": true,
      "address_2": "foo"
   },
   "questionnaire": {
      "ca_wia": false,
      "sc_fib": false,
      "unemployed": false,
      "ca_farmer": false,
      "cdib": false,
      "veteran": false,
      "ca_cal_works": false,
      "afdc": false,
      "voc_rehab": false,
      "ssi": true,
      "food_stamps": false,
      "ca_misdemeanor": false,
      "ca_foster": false,
      "felon": false
   },
   "hiring_manager_info": {
      "dojo": "2016-04-28",
      "doh": "2016-04-28",
      "dsw": "2016-04-28",
      "occupation_id": occupationId,
      "dgi": "2016-04-28",
      "starting_wage": "14.25"
   },
   "e_signatures": {
        "hm_signature": {
          "name": "John Doe",
          "title": "Hiring Manager",
          "esign": true,
          "authorization": true
        },
        "emp_signature": {
          "esign": true,
          "authorization": true
        }
  }
};
</cfscript>
</cffunction>


  <cffunction name="mapParameters" access="public" output="false" returntype="any" hint="I map old api parameters to new parameters needed for POSTing a new employee record">
      <cfargument name="params" type="struct" required="true" />
      <cfset local = {} />
      <cfset local.results = {} />
      <cfset local.results.error = "" />
      <cftry>
         <cfscript>
            var rt = getRetroTaxStruct();


            /*HIRING MANAGER SECTION */
            if(structkeyexists(params,"OCCUPATIONID")){rt.hiring_manager_info['occupation_id']=params['OCCUPATIONID'];}
            if(structkeyexists(params,"DGI")){rt.hiring_manager_info['dgi']=DateFormat(params['DGI'],"yyyy-mm-dd");}
            if(structkeyexists(params,"DOB")){rt.hiring_manager_info['dob']=DateFormat(params['DOB'],"yyyy-mm-dd");}
            if(structkeyexists(params,"DOH")){rt.hiring_manager_info['doh']=DateFormat(params['DOH'],"yyyy-mm-dd");}
            if(structkeyexists(params,"DOJO")){rt.hiring_manager_info['dojo']=DateFormat(params['DOJO'],"yyyy-mm-dd");}
            if(structkeyexists(params,"DSW")){rt.hiring_manager_info['dsw']=DateFormat(params['DSW'],"yyyy-mm-dd");}
            if(structkeyexists(params,"STARTINGWAGE")){rt.hiring_manager_info['starting_wage']=params['STARTINGWAGE'];}


            /*Employee Info */
            if(structkeyexists(params,"LASTNAME")){rt.employee_info['last_name']=params['LASTNAME'];}
            if(structkeyexists(params,"ZIP")){rt.employee_info['zip']=params['ZIP'];}
            if(structkeyexists(params,"STATE")){rt.employee_info['state']=params['STATE'];}
            if(structkeyexists(params,"SSN")){rt.employee_info['ssn']=ReReplaceNoCase(params['SSN'],"[^0-9,]","","ALL");}
            if(structkeyexists(params,"REHIRE")){rt.employee_info['rehire']=TrueFalseFormat(params['REHIRE']);}
            if(structkeyexists(params,"FIRSTNAME")){rt.employee_info['first_name']=params['FIRSTNAME'];}
            if(structkeyexists(params,"DOB")){rt.employee_info['dob']=DateFormat(params['DOB'],"yyyy-mm-dd");}
            if(structkeyexists(params,"CITY")){rt.employee_info['city']=params['CITY'];}
            if(structkeyexists(params,"ADDRESS")){rt.employee_info['address_line_1']=params['ADDRESS'];}
            if(structkeyexists(params,"ADDRESS2")){rt.employee_info['address_line_2']=params['ADDRESS2'];}
            if(structkeyexists(params,"LOCATIONID")){rt.employee_info['location_id']=params['LOCATIONID'];}
            if(structkeyexists(params,"SUFFIX")){rt.employee_info['suffix']=params['SUFFIX'];}


            /*QUESTIONAIRE*/
            if(structkeyexists(params,"FELON")){rt.questionnaire['felon']=TrueFalseFormat(params['FELON']);}
            if(structkeyexists(params,"CAFOSTER")){rt.questionnaire['ca_foster']=TrueFalseFormat(params['CAFOSTER']);}
            if(structkeyexists(params,"CAMISDEMEANOR")){rt.questionnaire['ca_misdemeanor']=TrueFalseFormat(params['CAMISDEMEANOR']);}
            if(structkeyexists(params,"FOODSTAMPS")){rt.questionnaire['food_stamps']=TrueFalseFormat(params['FOODSTAMPS']);}
            if(structkeyexists(params,"SSI")){rt.questionnaire['ssi']=TrueFalseFormat(params['SSI']);}
            if(structkeyexists(params,"VOCREHAB")){rt.questionnaire['voc_rehab']=TrueFalseFormat(params['VOCREHAB']);}
            if(structkeyexists(params,"AFDC")){rt.questionnaire['afdc']=TrueFalseFormat(params['AFDC']);}
            if(structkeyexists(params,"CDIB")){rt.questionnaire['cdib']=TrueFalseFormat(params['CDIB']);}
            if(structkeyexists(params,"CAFARMER")){rt.questionnaire['ca_farmer']=TrueFalseFormat(params['CAFARMER']);}
            if(structkeyexists(params,"UNEMPLOYED")){rt.questionnaire['unemployed']=TrueFalseFormat(params['UNEMPLOYED']);}
            if(structkeyexists(params,"CAFARMER")){rt.questionnaire['ca_farmer']=TrueFalseFormat(params['CAFARMER']);}
            if(structkeyexists(params,"CAWIA")){rt.questionnaire['ca_wia']=TrueFalseFormat(params['CAWIA']);}
            if(structkeyexists(params,"SCFIB")){rt.questionnaire['sc_fib']=TrueFalseFormat(params['SCFIB']);}
            if(structkeyexists(params,"VETERAN")){rt.questionnaire['veteran']=TrueFalseFormat(params['VETERAN']);}
            if(structkeyexists(params,"CACALWORKS")){rt.questionnaire['ca_cal works']=TrueFalseFormat(params['CACALWORKS']);}


            /* ESIGN */
            if(structkeyexists(params,"AUTHORIZATION")){rt.e_signatures.hm_signature['authorization']=TrueFalseFormat(params['AUTHORIZATION']);}
            if(structkeyexists(params,"ESIGN")){rt.e_signatures.hm_signature['esign']=TrueFalseFormat(params['ESIGN']);}
            if(structkeyexists(params,"HM_NAME")){rt.e_signatures.hm_signature['name']=params['HM_NAME'];}
            if(structkeyexists(params,"HM_TITLE")){rt.e_signatures.hm_signature['title']=params['HM_TITLE'];}


            /* VOC REHAB */
            if(structkeyexists(params,"VOCREHABINFO_ADDRESS")){voc_rehab_info['address_line_1']=params['VOCREHABINFO_ADDRESS'];}
            if(structkeyexists(params,"VOCREHABINFO_ADDRESS2")){rt.voc_rehab_info['address_line_2']=params['VOCREHABINFO_ADDRESS2'];}
            if(structkeyexists(params,"VOCREHABINFO_AGENCY")){rt.voc_rehab_info['agency_name']=params['VOCREHABINFO_AGENCY'];}
            if(structkeyexists(params,"VOCREHABINFO_CITY")){rt.voc_rehab_info['city']=params['VOCREHABINFO_CITY'];}
            if(structkeyexists(params,"VOCREHABINFO_COUNTY")){rt.voc_rehab_info['county']=params['VOCREHABINFO_COUNTY'];}
            if(structkeyexists(params,"VOCREHABINFO_PHONE")){rt.voc_rehab_info['phone']=params['VOCREHABINFO_PHONE'];}
            if(structkeyexists(params,"VOCREHABINFO_STATE")){rt.voc_rehab_info['state']=params['VOCREHABINFO_STATE'];}
            if(structkeyexists(params,"VOCREHABINFO_ZIP")){rt.voc_rehab_info['zip']=params['VOCREHABINFO_ZIP'];}
            if(structkeyexists(params,"TTW")){rt.voc_rehab_info['ttw']=TrueFalseFormat(params['TTW']);}
            if(structkeyexists(params,"DEPTVA")){rt.voc_rehab_info['dept_va']=TrueFalseFormat(params['DEPTVA']);}
            if(structkeyexists(params,"VOCREHABAGENCY")){rt.voc_rehab_info['is_agency']=TrueFalseFormat(params['VOCREHABAGENCY']);}


            if((structkeyexists(params,"VOCREHAB") && rt.questionnaire['voc_rehab']) &&
               (!rt.voc_rehab_info['ttw'] && !rt.voc_rehab_info['dept_va'] && !rt.voc_rehab_info['is_agency'])){
               rt.voc_rehab_info['is_agency']='true';}


            /* AFDC */
            if(structkeyexists(params,"AFDC") && params.afdc){
               if(structkeyexists(params,"RECIPIENT_CITYRECEIVED")){rt.afdc_recipient_info['city_received']=params['RECIPIENT_CITYRECEIVED'];}
               if(structkeyexists(params,"RECIPIENT_COUNTYRECEIVED")){rt.afdc_recipient_info['county_received']=params['RECIPIENT_COUNTYRECEIVED'];}
               if(structkeyexists(params,"RECIPIENT_NAME")){rt.afdc_recipient_info['name']=params['RECIPIENT_NAME'];}
               if(structkeyexists(params,"RECIPIENT_RELATIONSHIP")){rt.afdc_recipient_info['relationship']=params['RECIPIENT_RELATIONSHIP'];}
               if(structkeyexists(params,"RECIPIENT_STATERECEIVED")){rt.afdc_recipient_info['state_received']=params['RECIPIENT_STATERECEIVED'];}
            }


            /* RECIPIENT */
            if(structkeyexists(params,"FOODSTAMPS") && params.foodstamps){
               if(structkeyexists(params,"RECIPIENT_CITYRECEIVED")){rt.foodstamps_recipient_info['city_received']=params['RECIPIENT_CITYRECEIVED'];}
               if(structkeyexists(params,"RECIPIENT_COUNTYRECEIVED")){rt.foodstamps_recipient_info['county_received']=params['RECIPIENT_COUNTYRECEIVED'];}
               if(structkeyexists(params,"RECIPIENT_NAME")){rt.foodstamps_recipient_info['name']=params['RECIPIENT_NAME'];}
               if(structkeyexists(params,"RECIPIENT_RELATIONSHIP")){rt.foodstamps_recipient_info['relationship']=params['RECIPIENT_RELATIONSHIP'];}
               if(structkeyexists(params,"RECIPIENT_STATERECEIVED")){rt.foodstamps_recipient_info['state_received']=params['RECIPIENT_STATERECEIVED'];}
            }
            /* FELON */
            if(structkeyexists(params,"FELONINFO_DATECONVICTION")){rt.felon_info['conviction_date']=DateFormat(params['FELONINFO_DATECONVICTION'],"yyyy-mm-dd");}
            if(structkeyexists(params,"FELONINFO_DATERELEASE")){rt.felon_info['release_date']=DateFormat(params['FELONINFO_DATERELEASE'],"yyyy-mm-dd");}
            if(structkeyexists(params,"FELONINFO_ISFEDERALCONVICTION")){rt.felon_info['is_federal_conviction']=TrueFalseFormat(params['FELONINFO_ISFEDERALCONVICTION']);}
            if(structkeyexists(params,"FELONINFO_ISSTATECONVICTION")){rt.felon_info['is_state_conviction']=TrueFalseFormat(params['FELONINFO_ISSTATECONVICTION']);}
            if(structkeyexists(params,"FELONINFO_PAROLEOFFICER")){rt.felon_info['parole_officer']=params['FELONINFO_PAROLEOFFICER'];}
            if(structkeyexists(params,"FELONINFO_PAROLEOFFICERPHONE")){rt.felon_info['parole_officer_phone']=params['FELONINFO_PAROLEOFFICERPHONE'];}
            if(structkeyexists(params,"FELONINFO_STATEID")){rt.felon_info['felony_state']=params['FELONINFO_STATEID'];}
            if(structkeyexists(params,"FELONINFO_COUNTYID")){rt.felon_info['felony_county']=params['FELONINFO_COUNTYID'];}


            if((structkeyexists(params,"FELON") && rt.questionnaire['felon']) &&
               (!rt.felon_info['is_federal_conviction'] && !rt.felon_info['is_state_conviction'])){
               rt.felon_info['is_state_conviction']='true';}


            /*Unemployed*/
            if(structkeyexists(params,"UNEMPLOYEDSTART")){rt.unemployment_info['unemployment_start_date']=DateFormat(params['UNEMPLOYEDSTART'],"yyyy-mm-dd");}
            if(structkeyexists(params,"UNEMPLOYEDSTOP")){rt.unemployment_info['unemployment_stop_date']=DateFormat(params['UNEMPLOYEDSTOP'],"yyyy-mm-dd");}
            if(structkeyexists(params,"COMPENSATEDSTART")){rt.unemployment_info['compensation_start_date']=DateFormat(params['COMPENSATEDSTART'],"yyyy-mm-dd");}
            if(structkeyexists(params,"COMPENSATEDSTOP")){rt.unemployment_info['compensation_stop_date']=DateFormat(params['COMPENSATEDSTOP'],"yyyy-mm-dd");}
            if(structkeyexists(params,"COMPENSATED")){rt.unemployment_info['compensated']=TrueFalseFormat(params['COMPENSATED']);}
         
            /*Veteran*/
            if(structkeyexists(params,"VETERANINFO_BRANCHID")){
               switch(params['VETERANINFO_BRANCHID']){
                  case "1":
                     veteran_info['branch']="Army";
                     break;
                  case "2":
                     veteran_info['branch']="Army Reserve";
                     break;
                  case "3":
                     veteran_info['branch']="Army National Guard";
                     break;
                  case "4":
                     veteran_info['branch']="Marine Corps";
                     break;
                  case "5":
                     veteran_info['branch']="Marine Corps Reserve"; 
                     break;
                  case "6":
                     veteran_info['branch']="Navy"; 
                     break;
                  case "7":
                     veteran_info['branch']="Navy Reserve"; 
                     break;
                  case "8":
                     veteran_info['branch']="Air Force"; 
                     break;
                  case "9":
                     veteran_info['branch']="Air Force Reserve"; 
                     break;
                  case "10":
                     veteran_info['branch']="Air Guard"; 
                     break; 
                  case "11":
                     veteran_info['branch']="Coast Guard"; 
                     break;  
                  case "12":
                     veteran_info['branch']="Coast Guard Reserve"; 
                     break;                                      
                  default:
                     veteran_info['branch']="Army";
               }
            }
            if(structkeyexists(params,"VETERANINFO_SERVICESTART")){rt.veteran_info['service_start']=DateFormat(params['VETERANINFO_SERVICESTART'],"yyyy-mm-dd");}
            if(structkeyexists(params,"VETERANINFO_SERVICESTOP")){rt.veteran_info['service_stop']=DateFormat(params['VETERANINFO_SERVICESTOP'],"yyyy-mm-dd");}
            if(structkeyexists(params,"DISABLED")){rt.veteran_info['disabled']=TrueFalseFormat(params['DISABLED']);}


         </cfscript>
         <cfset local.results = rt>
         <cfcatch type="any">
            <cfset local.results.error = cfcatch.message & " " & cfcatch.detail />
         </cfcatch>
      </cftry>
      <cfreturn local.results />
   </cffunction>


   <cfscript>
      //source: http://cflib.org/udf/TrueFalseFormat
      function TrueFalseFormat(exp){
        if (exp) return true;
        return false;
      }
   </cfscript>
</cfcomponent>