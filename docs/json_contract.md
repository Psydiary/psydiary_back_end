Psydiary JSON Contract
### New User Create
---
 Request: `post 'api/v1/user'`

 Response:
```
{ 
	"data": {
		"id": "1",
		"type": "user",
		"attributes": {
			"name": "name",
			"email": "email",
			"password": "password"
			"ip_address": "ip_address"
			"protocol_id": 1,
			"data_sharing": boolean
		}
	}
}
```
