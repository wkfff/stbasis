        ��  ��                  �  4   ��>D R I V E R _ H E L P       0 	        <p class="h1">ADO Driver</p>
<p>
  This Driver allows you to connect to data sources accessible via ADO.
</p>

<p class="h2">Step 2: Aux Driver</p>
<p>
  ADO provides access to different database systems, such as Microsoft SQL Server, ODBC and Microsoft Office Access.
  Please select the appropriate ADO subdriver from the list. For example, SQL Server requires SQLOLEDB.1, for ODBC you need MSDASQL.1 and for Access it is Microsoft.Jet.OLEDB.4.0.
</p>

<p class="h2">Step 3: Server Name</p>
<p>
  In this field, provide the host name or the IP address of the server to which you are connecting.
</p>

<p class="h2">Step 4: Login</p>
<p>
  Use these two fields to provide a username and password to access the database server. These fields are not used for SQL Server when using Windows Authentication (but see the Custom parameters step below).
</p>

<p class="h2">Step 5: Database</p>
<p>
  Specify the database to which you wish to connect. Depending on the selected Sub-driver, this might be the name of a database entity (e.g. "Northwind" for SQL Server), or a complete path and filename (e.g. "D:\DB\db1.mdb" for Access).
</p>

<p class="h2">Step 6: Custom parameters</p>
<p>
  You can specify additional ADO-driver specific options as a semicolon separated list of name/value pairs. For SQL Server using Windows Authentication you will need to add 'Integrated Security=SSPI' here.
  Please consult the ADO documentation for details on the other options available.
</p>
