# Application Properties
You will need to create an application.properties file in the resources folder of the project. This file will contain the following properties:

```
url=jdbc:mysql://localhost:3306/your_database_name
```

You can get this JDBC connection string from your database on Azure. 
Make sure you replace '{your_password}' with your actual password, 
but don't check this into git as it will then leak your password (and your entire connection string) to the public. This is best practice in industry as well.

