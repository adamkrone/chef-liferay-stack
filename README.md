# liferay-stack

Installs and configures elements of a full Liferay application stack. It is
assumed that deployment is handled separately through something like
Capistrano.

## LWRPs

This cookbook is intended to be consumed through its LWRPs, and therefore
doesn't include any recipes. Here is an overview of the LWRPs provided:

**Note:** The first attribute listed for each LWRP is also the name attribute.

### liferay_stack_app

Configures the Liferay application environment.

#### Attributes:

| Name             | Description                                                      | Type   | Required | Default                                                            |
| ---------------- | ---------------------------------------------------------------- | ------ | -------- | ------------------------------------------------------------------ |
| app_name         | Name of the application.                                         | String | true     | N/A                                                                |
| deployment_user  | User that owns the deployment/application.                       | String | false    | 'liferay'                                                          |
| deployment_group | Group that owns the deployment/application.                      | String | false    | 'liferay'                                                          |
| home_dir         | Home directory for Liferay app.                                  | String | false    | '/opt/liferay/current/liferay-portal-6.2-ce-ga4'                   |
| tomcat_dir       | Tomcat directory in the Liferay bundle.                          | String | false    | '/opt/liferay/current/liferay-portal-6.2-ce-ga4/tomcat-7.0.42      |
| log_dir          | Tomcat log directory.                                            | String | false    | '/opt/liferay/current/liferay-portal-6.2-ce-ga4/tomcat-7.0.42/logs |
| github_accounts  | Github accounts to use for setting up public keys for ssh access | Array  | true     | N/A                                                                |

#### Example:

```ruby
liferay_stack_app 'my-app' do
  github_accounts ['adamkrone']
end
```

### liferay_stack_database

Configures a database for the Liferay application environment.

#### Attributes:

| Name                | Description                                     | Type   | Required | Default |
| ------------------- | ----------------------------------------------- | ------ | -------- | ------- |
| name                | Name of MySQL Database.                         | String | true     | N/A     |
| user                | MySQL user that owns the database.              | String | true     | N/A     |
| user_password       | Password for MySQL user that owns the database. | String | true     | N/A     |
| hosts               | Hosts user can connect from.                    | Array  | true     | N/A     |
| mysql_root_password | Password for MySQL Root user.                   | String | true     | N/A     |

#### Example:

```ruby
liferay_stack_database 'my-app-db' do
  user 'my-user'
  user_password 'my-user-password'
  hosts ['localhost']
  mysql_root_password 'mysql-root-password'
end
```

### liferay_stack_shared_file

Configures a shared file for use with Capistrano deployments.

#### Attributes:

| Name             | Description                                             | Type    | Required | Default               |
| ---------------- | ------------------------------------------------------- | ------- | -------- | --------------------- |
| file_name        | Name of the shared file.                                | String  | true     | N/A                   |
| template         | Template to render shared file.                         | String  | true     | N/A                   |
| shared_path      | Path inside shared directory where shared file resides. | String  | true     | N/A                   |
| owner            | Owner of the shared directory/file.                     | String  | false    | 'liferay'             |
| group            | Group of the shared directory/file.                     | String  | false    | 'liferay'             |
| shared_directory | Capistrano shared directory root.                       | String  | false    | '/opt/liferay/shared' |

#### Example:

```ruby
liferay_stack_shared_file 'ROOT.xml' do
  template 'ROOT.xml.erb'
  shared_path 'liferay-portal-6.2-ce-ga4/tomcat-7.0.42/conf/Catalina/localhost'
end
```
