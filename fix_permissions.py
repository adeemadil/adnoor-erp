#!/usr/bin/env python3
"""
Script to fix admin user permissions in ERPNext
"""
import frappe

def fix_admin_permissions():
    try:
        # Get the admin user
        user = frappe.get_doc('User', 'admin-erp@adnoor.ca')
        
        # Add System Manager and Administrator roles
        user.add_roles('System Manager', 'Administrator')
        user.save()
        
        # Commit the changes
        frappe.db.commit()
        
        print("✅ Successfully added System Manager and Administrator roles to admin-erp@adnoor.ca")
        
        # Also ensure the user has all necessary permissions
        user.reload()
        print(f"User roles: {user.get('roles')}")
        
    except Exception as e:
        print(f"❌ Error: {e}")
        frappe.db.rollback()

if __name__ == "__main__":
    fix_admin_permissions()
