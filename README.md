# (ColdFusion) RetroTax API

Detailed API REST documentation can be found at [RetroTax's Developer site](https://developer.retrotax-aci.com/jbt/markdown-editor).

### API End Points

*Staging - https://api-sni-staging.retrotax-aci.com or https://api-staging.retrotax-aci.com

*Production - https://api-sni.retrotax-aci.com or https://api.retrotax-aci.com

ColdFusion doesn't play well SNI-enabled SSL certs, which we have through AWS Gateway, so api-sni.retrotax-aci.com and api-sni.staging.retrotax-aci.com are proxy instances setup to handle requests for non-SNI-enabled clients. Set apiUrl argument to the correct URL when initializing the RetroTax CF component.

### JsonSerializer
This library makes use of Ben Nadel's JSON Serializer when calling Employee's POST method.  Read more about it here:

http://www.bennadel.com/blog/2505-jsonserializer-cfc---a-data-serialization-utility-for-coldfusion.htm


Sample CFScript! :+1:

## Authentication

```javascript
var RetroTax = createObject("component",
"services.RetroTax").init(username:"",key:"",authToken:"",apiUrl:"https://api-sni-staging.retrotax-aci.com");

//Example signIn
var r=RetroTax.signIn();
var signInResponse=deserializeJSON(r['Filecontent']);

//Example setCredentials
RetroTax.setCredentials(authToken:signInResponse.auth_token);

var employeeStruct=RetroTax.getRetroTaxStruct();
writeDump(var=employeeStruct,label="employeeStruct",expand=false);

//Example signOut
var r=RetroTax.signOut();
var signOutResponse=deserializeJSON(r['Filecontent']);
```

## Companies Resource

```javascript
//Example getCompanies: Returns client's list of companies
var r = RetroTax.getCompanies();
var companies=deserializeJSON(r['Filecontent']);

//Example getCompany
var r = RetroTax.getCompany(companyId:companies[1].id);
var company=deserializeJSON(r['Filecontent']);
```

## Locations Resource

```javascript

//Example getLocations
var r = RetroTax.getLocations(companyId:companies[1].id);
var locations=deserializeJSON(r['Filecontent']);

//Example getEmployees by location
var r = RetroTax.getEmployees(locationId:locations[1].id);
var employees=deserializeJSON(r['Filecontent']);
```

## Employees Resource

```javascript

//Example getEmployees by location and return a set of 10 employees at the 5th page
var r = RetroTax.getEmployees(locationId:locations[1].id,page:5,per_page:10);
var employeesFiltered=deserializeJSON(r['Filecontent']);

//Example getEmployees filter by status equal to 'not qualified'
var r = RetroTax.getEmployees(locationId:locations[1].id,status:'NQ');
var notQualifiedEmployees=deserializeJSON(r['Filecontent']);

//Example getEmployees filter by status equal to 'sent to state'
var r = RetroTax.getEmployees(locationId:locations[1].id,status:'SS');
var qualifiedEmployees=deserializeJSON(r['Filecontent']);
//Example getPayEntries
var r = RetroTax.postPayEntry(employeeId:qualifiedEmployees.list[1].employee_info.id,wages:"9.0",hours:"40.0",start_date:"2016/08/01",end_date:"2016/08/01");

//Example getPayEntries
var r = RetroTax.getPayEntries(employeeId:qualifiedEmployees.list[1].employee_info.id);

//Example getEmployees search
var r = RetroTax.getEmployees(locationId:locations[1].id,search:'Test');

//Example getEmployees filter by status equal 'sent to state'
var r = RetroTax.getEmployees(locationId:locations[1].id,status:'SS');

//Example getDocuments filter by missing
var status='missing';
var employeeId=sentToStateEmployees.list[1].employee_info.id;
var r = RetroTax.getDocuments(employeeId:employeeId,status:status);

//Example postDocuments
var filePath=ExpandPath('/services/test.pdf');
var r = RetroTax.postDocuments(employeeId:employeeId,filePath:filePath,documentCode:'DD-214',documentMimeType:"application/pdf");

//Example getDocuments
var r = RetroTax.getDocuments(employeeId:employeeId);

//Example createTestEmployee & postEmployee
serializer=new Services.JSONserializer().asString("ssn").asString("zip").asInteger("occupation_id");
var testEmployee=RetroTax.createTestEmployee();
var r=RetroTax.postEmployee(params:testEmployee);

//Example updateEmployee
newEmployee.questionnaire.cdib=true;
writeDump(var=newEmployee,label="newEmployee",expand=false);
var r = RetroTax.updateEmployee(employeeId:newEmployee.employee_info.id,params:serializeJSON(newEmployee.questionnaire));

//Example eSign
var r = RetroTax.eSign(employeeId:newEmployee.employee_info.id,
hiringManagerTitle:"Hiring Manager",hiringManagerName:"Angie Mackey");
```

## States Resource

```javascript
//Example getStates
var r = RetroTax.getStates();
var states=deserializeJSON(r['Filecontent']);
```

## Counties Resource

```javascript
//Example getCounties
var r = RetroTax.getCounties(stateCode:states[1].code);
```

## Occupations Resource

```javascript
//Example getOccupations
var r = RetroTax.getOccupations();
```

## Branches Resource

```javascript
//Example getBranches
var r=RetroTax.getBranches();
```

## Helper Functions

```javascript
//Returns properly formatted structure to create new records.  Currently defaults some parameters to common values. 
var employeeStruct=RetroTax.getRetroTaxStruct();

{
	"afdc_recipient_info": {
		"name": "",
		"county_received": "",
		"city_received": "",
		"state_received": "",
		"relationship": ""
	},
	"felon_info": {
		"is_state_conviction": "",
		"release_date": "",
		"parole_officer_name": "",
		"conviction_date": "",
		"is_federal_conviction": "",
		"parole_officer_phone": ""
	},
	"employee_info": {
		"location_id": "",
		"state": "",
		"zip": "",
		"first_name": "",
		"dob": "",
		"suffix": "",
		"ssn": "",
		"rehire": false,
		"city": "",
		"address_line_2": "",
		"address_line_1": "",
		"last_name": ""
	},
	"unemployment_info": {
		"compensated_start_date": "",
		"unemployment_start_date": "",
		"compensated": "",
		"compensated_stop_date": "",
		"unemployment_stop_date": ""
	},
	"benefits_recipient_info": {
		"name": "",
		"county_received": "",
		"city_received": "",
		"state_received": "",
		"relationship": ""
	},
	"hiring_manager_info": {
		"dsw": "2016\/08\/14",
		"dojo": "2016\/08\/14",
		"occupation_id": "",
		"dgi": "2016\/08\/14",
		"starting_wage": "",
		"doh": "2016\/08\/14"
	},
	"voc_rehab_info": {
		"phone": "",
		"county": "",
		"state": "",
		"zip": "",
		"address_1": "",
		"is_agency": "",
		"address_2": "",
		"city": "",
		"dept_va": "",
		"agency_name": ""
	},
	"questionnaire": {
		"ca_foster": false,
		"ca_cal_works": false,
		"ssi": false,
		"veteran": false,
		"ca_misdemeanor": false,
		"ca_wia": false,
		"scfib": false,
		"food_stamps": false,
		"afdc": false,
		"cdib": false,
		"ca_farmer": false,
		"unemployed": false,
		"voc_rehab": false,
		"felon": false
	},
	"veteran_info": {
		"service_stop": "",
		"disabled": "",
		"branch": "Army",
		"service_start": ""
	}
}
```