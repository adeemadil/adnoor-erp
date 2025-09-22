# AdNoor ERP User Roles Testing Guide

## Current User Accounts in Your ERPNext Instance

Based on the production data restoration, you have the following users available:

### System Users (Have ERPNext Access)
1. **Administrator** - admin@example.com (Full system access)
2. **adilayub@adnoor.ca** - Adil Ayub's account
3. **ahrazfaheem@adnoor.ca** - Ahraz Faheem's account  
4. **mazhardars2010@gmail.com** - Mazhar's account
5. **murtazakazi@adnoor.ca** - Murtaza Kazi's account
6. **mustafarao@gmail.com** - Mustafa's account
7. **noorfazalkarim@adnoor.ca** - Noor Fazal's account
8. **rabiakazi@adnoor.ca** - Rabia Kazi's account
9. **sk@adnoor.ca** - SK's account

### Website Users
- **Guest** - guest@example.com (Limited access)

## Available ERPNext Roles

Your system has the following roles with desk access:

### Core Business Roles
- **Administrator** - Full system access
- **System Manager** - System administration
- **Accounts Manager** - Financial management
- **Accounts User** - Basic accounting access
- **HR Manager** - Human resources management
- **HR User** - Basic HR access
- **Employee** - Basic employee access

### Specialized Roles
- **Academics User** - Educational features
- **Agriculture Manager/User** - Agricultural features
- **Analytics** - Reporting and analytics
- **Auditor** - Audit and compliance
- **Blogger** - Content management
- **Dashboard Manager** - Dashboard configuration
- **Delivery Manager/User** - Logistics and delivery
- **Desk User** - Basic desk access
- **Expense Approver** - Expense approval
- **Fleet Manager** - Fleet management
- **Fulfillment User** - Order fulfillment
- **Projects Manager** - Project management

## How to Test Different User Roles

### Method 1: Check Current User Roles
1. **Login as Administrator** (admin@example.com / admin123)
2. **Go to**: Settings → Users and Permissions → User
3. **Click on any user** to see their assigned roles
4. **Check "Roles" tab** to see what permissions they have

### Method 2: Test User Access Directly
1. **Try logging in** with different user emails
2. **Use the same password** (admin123) or reset if needed
3. **Observe what menus and features** each user can access

### Method 3: Assign/Modify Roles
1. **Login as Administrator**
2. **Go to**: Settings → Users and Permissions → User
3. **Edit any user** → Go to "Roles" tab
4. **Add/Remove roles** as needed
5. **Save** and test the changes

## Testing Different Access Levels

### 1. Test Accounts Manager Role
- **Login with**: Accounts Manager role user
- **Should access**: Chart of Accounts, Journal Entries, Payment Entries, Invoices
- **Should NOT access**: User management, System settings

### 2. Test HR Manager Role  
- **Login with**: HR Manager role user
- **Should access**: Employee records, Leave applications, Payroll
- **Should NOT access**: Financial data, System settings

### 3. Test Employee Role
- **Login with**: Employee role user
- **Should access**: Own profile, Leave applications, basic reports
- **Should NOT access**: Financial data, user management, system settings

### 4. Test Auditor Role
- **Login with**: Auditor role user
- **Should access**: All financial reports, audit trails, compliance data
- **Should NOT access**: Ability to modify financial data

## Creating Test Users

### Create a New User with Specific Role
1. **Login as Administrator**
2. **Go to**: Settings → Users and Permissions → User
3. **Click "New"**
4. **Fill in details**:
   - Email: test.user@adnoor.ca
   - First Name: Test
   - Last Name: User
   - User Type: System User
5. **Go to "Roles" tab**
6. **Select desired role** (e.g., "Accounts User")
7. **Save**
8. **Set password**: Go to user → "Reset Password"

## Role-Based Feature Testing

### Accounts Manager Testing
- ✅ Create/Edit Chart of Accounts
- ✅ Create Journal Entries
- ✅ Process Payment Entries
- ✅ Generate Financial Reports
- ❌ Access User Management
- ❌ Modify System Settings

### HR Manager Testing
- ✅ Manage Employee records
- ✅ Process Leave applications
- ✅ Access Payroll module
- ✅ Generate HR reports
- ❌ Access Financial data
- ❌ Modify User roles

### Employee Testing
- ✅ View own profile
- ✅ Apply for leave
- ✅ View own salary details
- ✅ Access basic reports
- ❌ View other employees' data
- ❌ Access financial modules

## Password Reset Commands

If you need to reset passwords for testing:

```bash
# Reset password for any user
docker exec frappe-backend-1 bench --site adnoor-dev.local set-admin-password newpassword

# Or reset specific user password
docker exec frappe-backend-1 bench --site adnoor-dev.local console
# Then in console:
# frappe.set_password("user@example.com", "newpassword")
```

## Testing Workflow

### Step 1: Test Current Users
1. Try logging in with each user email
2. Note what access they have
3. Document their current roles

### Step 2: Modify Roles
1. Login as Administrator
2. Edit user roles as needed
3. Test the changes

### Step 3: Create Test Scenarios
1. Create test users with specific roles
2. Test business workflows with different access levels
3. Verify security and permissions work correctly

## Security Testing

### Verify Role Restrictions
- **Financial Data**: Only accounts users should access
- **HR Data**: Only HR users should access  
- **System Settings**: Only administrators should access
- **User Management**: Only system managers should access

### Test Data Isolation
- **Employee A** should not see Employee B's personal data
- **Department A** should not see Department B's financial data
- **Regional users** should only see their region's data (when implemented)

## Next Steps for Role Customization

Based on your AdNoor requirements, you'll need to create custom roles for:

1. **Procurement Manager** - Full procurement access
2. **Buyer** - Prepare purchase orders
3. **Manager** - Approve orders
4. **Finance** - View-only access
5. **Warehouse User** - Inventory management
6. **Regional Manager** - Region-specific access
7. **CEO** - Executive dashboard access
8. **Supplier** - Limited supplier portal access

These custom roles will be created in Phase 2 of your implementation plan.
