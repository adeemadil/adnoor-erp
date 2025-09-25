# AdNoor ERP Implementation Plan

## 30-Day Trial Plan (Client-Facing)

### Executive Summary
- We will stand up a secure, fully controlled ERPNext stack owned by AdNoor, mirror production’s working pieces, and deliver mandatory core modules in 30 days with weekly demos and clear acceptance criteria. If the trial passes, we continue into Phases 2–7.

### Goals (Trial)
- Recreate a clean, controllable ERPNext under AdNoor’s Git + Docker.
- Prove end-to-end core flows: Buy → Stock → Sell → Invoice/Payment → GL.
- Establish security, backups, and dev → staging → prod workflow.

### In-Scope Modules (Mandatory)
- Sales: Quotations, Sales Orders
- Buying: Purchase Orders
- Accounting: Sales/Purchase Invoices, Payments, Journal Entries, GL
- Master Data: Items, Customers, Suppliers, Warehouses, basic Price Lists
- Inventory: Stock ledger/balance, Receipts/Issues, simple Reorder levels
- People & Access: Roles/permissions
- Reporting: Starter Ops Dashboard + key reports (Sales, Purchase, Stock, AR/AP, P&L)

### Out of Scope (Deferred to Roadmap)
- Custom workflows/dashboards, telephony, supplier portal, logistics integrations, mobile apps, POS, advanced pricing/commission logic.

### Deliverables (Within 30 Days)
- Environments & Ownership: Dockerized bench; versioned repo; infra scripts; staging that mirrors prod data; prod on Contabo; one-command backup & documented restore.
- Configuration & Data: Templates + initial imports for Items, Customers, Suppliers, Warehouses, basic Price Lists; optional opening stock; COA/tax templates/payment modes validated.
- Core Transactions: Quote→SO→Delivery Note/Invoice; PO→GRN/Bill; stock movement reflects in ledgers; GL postings verified.
- Security & Ops: Roles/permissions; SSL/reverse proxy (prod); daily encrypted backups; scheduled verification restore; health checks and log rotation; email muted in non-prod.
- Reporting: One Ops Dashboard with tiles: Orders today, Pending PO Receipts, Stock below reorder, AR aging, AP aging, Sales this month vs LY.
- Docs & Handover: Runbook (start/stop/backup/restore/deploy), config workbook, short loom videos, UAT scripts + sign-off checklist.

### Acceptance Criteria (Go/No-Go)
- 100% of mandatory flows executed in UAT without blocking issues.
- 0 unresolved P1 defects; ≤3 minor defects with workarounds.
- Sample parity checks (10 SOs, 10 POs, 10 invoices) match expected ledgers.
- Daily backups verified by an actual restore to staging.
- AdNoor admin has full control (Git, credentials, bench, DB) — no vendor lock-in.

### 30-Day Schedule
- Week 1 – Foundations: Repo + Docker finalized; staging live; restore prod backup to staging; security hardening; mute emails in non-prod; roles/permissions draft; confirm COA/tax templates.
- Week 2 – Masters & Config: Import master data; configure Buying/Selling/Stock settings; basic reorders; build starter Ops Dashboard.
- Week 3 – Transactions & GL: Sales flow and Buying flow with test data; validate stock & GL postings; remediate gaps.
- Week 4 – UAT & Hardening: UAT runs; fix/retune; backup/restore drill; finalize runbook & quick-start; Go/No-Go review and Phase-2 backlog grooming.

### Cadence
- Stand-up 3×/week (15 min), weekly demo (45–60 min), UAT sign-off end of Week 4.

### Dependencies (Day 1)
- SSH to Contabo (backup/restore), trial users + roles, tax templates/price rules/special posting rules, and sample data extracts (if full prod data not used).

## Project Overview
- **Production**: https://adnoorerp.com (Contabo VM)
- **Development**: http://localhost:8080 (Laptop)
- **Repository**: adnoor-erp
- **Framework**: Frappe Framework + ERPNext v15.79.0
- **Setup Method**: Local dev via easy install; Staging/Prod via Docker Compose (frappe_docker)

### Environments
- **Development (Local)**: `adnoor-dev.local` (emails muted; developer mode enabled)
- **Staging**: Dockerized bench mirroring production data (emails muted; developer mode enabled)
- **Production**: Contabo VM with SSL/reverse proxy, backups, monitoring

## Current Status

### ✅ Completed
- [x] Project structure setup
- [x] Basic documentation
- [x] Easy install script downloaded
- [x] Git repository initialized
- [x] **ERPNext v15.79.0 successfully installed**
- [x] **Development environment running**
- [x] **Site created: adnoor-dev.local**
- [x] **Frappe Docker repository cloned**
- [x] **Configuration files created**

### 🔄 In Progress
- [ ] Custom app creation (adnoor_custom)
- [ ] Initial ERPNext configuration and testing
- [ ] User roles and permissions setup

### ❌ Pending
- [ ] Production deployment
- [ ] SSL configuration
- [ ] Backup strategy
- [ ] Monitoring setup

## Phase 1: Core ERPNext Setup (Current)

### 1.1 Development Environment
- [x] Project structure created
- [x] **Easy install script setup**
- [x] **Development environment deployment**
- [x] **Local domain configuration (https://adnoor-dev.local)**
- [x] **Basic site setup and testing**
- [x] **Access and verify ERPNext instance**
- [x] **Login working (Administrator / admin123)**

### 1.2 Custom App (Postponed)
- [ ] Postpone creating `adnoor_custom` until a real gap appears (e.g., repeat-order button, procurement dashboards, complex integrations)
- [ ] Keep using ERPNext/installed apps via Administrator for configuration
- [ ] When ready: create minimal app only to store fixtures and any code

### 1.3 Core ERPNext Configuration
- [x] Install ERPNext v15.79.0
- [x] **Complete setup wizard (Company: AdNoor, Abbreviation: ANC)**
- [x] **Restore production data from Contabo backups**
- [x] **Install HRMS app to match production**
- [x] **Database migration completed successfully**
- [ ] Configure basic settings and verify data integrity
- [ ] Set up user roles and permissions
- [ ] Configure company information
- [ ] Test user access and role-based permissions

## Phase 2: AdNoor Business Process Implementation

### 2.1 Core ERPNext Flows (Phase 1 - 2-3 Weeks) ✅
- [x] **Sales Orders** - Basic functionality working
- [x] **Purchase Orders** - Basic functionality working  
- [x] **Quotations** - Basic functionality working
- [x] **Invoices & Payments** - Basic functionality working
- [x] **Product Master** - Basic functionality working
- [x] **Customer/Supplier Profiles** - Basic functionality working
- [x] **Warehouse & Inventory** - Basic functionality working
- [x] **Journal Entries & GL** - Basic functionality working
- [x] **Employee Roles & Permissions** - Basic functionality working
- [x] **Reports Dashboard** - Basic functionality working

### 2.2 AdNoor Custom Procurement Features (Phase 2 - 4-5 Weeks)
- [ ] **Weekly Task Manager**
- [ ] **Procurement Dashboard**
- [ ] **Lead & Data Team Workflow**
- [ ] **Reorder + Delivery Scheduling Automation**
- [ ] **Container Costing Tool (Quarterly)**
- [ ] **Commission Calculation System**
- [ ] **Price Management (Wholesale/Retail)**
- [ ] **CEO Dashboard**
- [ ] **Audit Trail**
- [ ] **Notifications Module**
- [ ] **Role-Based Dashboards**
- [ ] **Restaurant & Distributor Data Reporting**
- [ ] **User Login Duration & Activity Tracking**

### 2.3 Procurement Software Requirements (From SRS)
- [ ] **Repeat Order Button**
- [ ] **Reorder Reminders** (based on stock flow & lead time)
- [ ] **Internal Notes on Orders**
- [ ] **Auto-generated order summaries**
- [ ] **Stock Tracking** - Real-time stock view by SKU and warehouse
- [ ] **Minimum quantity alerts**
- [ ] **Procurement Calendar** - Visual view of all procurement activities
- [ ] **Status indicators**: upcoming, in progress, delayed
- [ ] **Reports Module** (Visual & Downloadable):
  - [ ] Top Supplier by SKU (total spend)
  - [ ] Origin Analysis (% by country/estate/city/area)
  - [ ] Average Monthly Buying Trends
  - [ ] Top Performing SKUs
  - [ ] Lead Time Tracking
  - [ ] Cost Over Time (SKU/Supplier/Origin)
  - [ ] Forecast vs Actual Spend
  - [ ] Pending PIs & Approval Status

### 2.4 New Customer Procurement Pipeline (90 Days Total)
- [ ] **Design Artwork** → **Approve & Test Blend** (30 days)
- [ ] **Send Deposit to Supplier** → **Print Bags** → **Arrange Shipping** → **Production** → **Ship**
- [ ] **Arrival Notice Received** → **Documents Sent to Custom Broker** → **Telex Released** → **Pickup # Received** (60 days)
- [ ] **Automated Integration** with Pipedrive CRM for wholesale deals
- [ ] **Procurement Pipeline Status** tracking and notifications

### 2.5 Recurring Customer Pipeline (Monthly Schedule)
- [ ] **Send Deposit to Supplier** → **Bags Printed** → **Arrange Shipping** → **Production** → **Ship**
- [ ] **Arrival Notice Received** → **Documents Sent to Custom Broker** → **Telex Released** → **Pickup # Received**
- [ ] **Fixed monthly schedule display** for each recurring client
- [ ] **Timeline management** for on-time delivery

### 2.6 Advanced Procurement Features
- [ ] **Procurement Task Checklist** (Per Order)
- [ ] **Delay Alerts and Risk Flags** (Red/Yellow warnings)
- [ ] **Price Tracker by SKU** (Last 3-5 prices per supplier)
- [ ] **Purchase Order Status Tracker** (Draft → Submitted → Approved → Confirmed → Shipped)
- [ ] **Order Summary Notes** (Auto-Generated)
- [ ] **SKU Information Center** (Supplier history, blend details, artwork, test reports)
- [ ] **Supplier Communication Log** (Email/document tracking)
- [ ] **Vendor Rating System** (Quality, speed, communication rating)
- [ ] **Stock Reservation for Orders**
- [ ] **FIFO (First In First Out) Control**

### 2.3 Reporting and Analytics
- [ ] **Basic Reports**
  - [ ] Sales reports
  - [ ] Purchase reports
  - [ ] Inventory reports
  - [ ] Financial reports
- [ ] **Print Formats**
  - [ ] Invoice formats
  - [ ] Order formats
  - [ ] Custom letterheads
- [ ] **Dashboards**
  - [ ] Executive dashboard
  - [ ] Department dashboards
  - [ ] KPI tracking
  - [ ] Operations Dashboard tiles: Orders today, Pending PO Receipts, Stock below reorder, AR aging, AP aging, Sales MTD vs LY

## Phase 3: Delivery & Logistics Integration (3-4 Weeks)
- [ ] **Delivery/Dispatch Module**
- [ ] **Goods Receipt Note (GRN)**
- [ ] **Mobile App for Drivers**
- [ ] **Tracking & Fulfilment Updates**
- [ ] **Regional Task Assignment**

## Phase 4: Supplier Portal + Region Expansion (3-4 Weeks)
- [ ] **Supplier Dashboard** (Packing, Dispatch, Production Updates)
- [ ] **City/Province Management View**
- [ ] **Region/Warehouse Task Assignment**
- [ ] **Container Workflow Integration**
- [ ] **Admin Monitoring of Region-wise Activity**

## Phase 5: Twilio Telephony & Call Center Integration (3-4 Weeks)
- [x] **CRM Core Workflows** (Lead intake, Filtering, Assignment, Follow-ups)
- [ ] **Click-to-Call from CRM**
- [ ] **In-Browser Softphone** (WebRTC via Twilio)
- [ ] **Call Logging & Recording**
- [ ] **Follow-Up Task Generation**
- [ ] **Call Outcome & Disposition Tracking**
- [ ] **Agent Performance Reports**
- [ ] **Regional Call Analytics**

## Phase 6: Mobile App (4-6 Weeks, Parallel Development)
- [ ] **Drivers App**
- [ ] **Admins (lite view)**
- [ ] **Optional: B2B/B2C customers**

## Phase 7: Smart Expansion (3-4 Weeks)
- [ ] **POS System**
- [ ] **Barcode/QR Workflow**
- [ ] **Vendor Onboarding System**

## Phase 8: Production Deployment & Security

### 8.1 Full Control & Security Implementation
- [ ] **Complete source code ownership** (No vendor lock-in)
- [ ] **Full admin panel access** (Frontend customization without code)
- [ ] **Custom field addition** capability
- [ ] **Database access** for advanced users
- [ ] **Backup and recovery** procedures
- [ ] **Documentation** for all customizations
 - [ ] **All IP owned by AdNoor** (source code, configs, infra scripts in AdNoor Git)

### 8.2 Production Environment Setup
- [ ] **Contabo VM optimization**
- [ ] **SSL certificate setup**
- [ ] **Production deployment**
- [ ] **Performance optimization**
- [ ] **Monitoring setup**

## Development Workflow

### Local Development
1. **Setup**: Use easy install script for development environment
2. **Development**: Make changes in adnoor_custom app
3. **Testing**: Test all changes locally
4. **Version Control**: Commit changes to git
5. **Deployment**: Deploy to production when ready

### Production Deployment
1. **Preparation**: Ensure all changes are tested locally
2. **Deployment**: Use deployment scripts for Contabo VM
3. **Validation**: Verify deployment success
4. **Monitoring**: Monitor system performance
5. **Backup**: Ensure backups are working

### Backups & Restore (Operations)
- Daily encrypted backups scheduled in production
- Use `scripts/backup.sh` for backups and `scripts/restore.sh` for restores
- Monthly verification restore drill to staging (pass/fail recorded)
- Log rotation and basic health checks configured

## Technical Architecture

### Development Environment
- **Framework**: Frappe Framework
- **Database**: MariaDB
- **Cache**: Redis
- **Web Server**: Nginx
- **Setup**: Docker containers via easy install script

### Production Environment
- **Server**: Contabo VM
- **Domain**: adnoorerp.com
- **SSL**: Let's Encrypt (automatic)
- **Backup**: Automated daily backups
- **Monitoring**: System monitoring and alerts

## Key Principles

1. **All customizations in adnoor_custom app**
   - Custom fields
   - Custom forms
   - Custom reports
   - Custom workflows

2. **Version control for all changes**
   - Export fixtures for customizations
   - Track all code changes
   - Maintain deployment history

3. **Test locally before production**
   - Full testing in development environment
   - Validate all business processes
   - Performance testing

4. **Mirror production data structure**
   - Keep development and production in sync
   - Regular data synchronization
   - Consistent configuration

5. **Proper git workflow**
   - Feature branches for development
   - Code reviews before merging
   - Tagged releases for production

## Common Commands

### Development
```bash
# Start development environment
./scripts/start-dev.sh

# Create custom app
bench new-app --no-git adnoor_custom

# Install custom app
bench --site sitename install-app adnoor_custom

# Export fixtures
bench --site sitename export-fixtures

# Build assets
bench build
```

### Production
```bash
# Deploy to production
./scripts/deploy-production.sh

# Backup site
bench --site sitename backup --with-files

# Restore backup
bench --site sitename restore /path/to/backup
```

## Risk Management

### Technical Risks
- **Data Loss**: Regular backups and testing
- **Performance Issues**: Monitoring and optimization
- **Security**: Regular updates and security audits
- **Integration Issues**: Thorough testing of integrations

### Business Risks
- **User Adoption**: Comprehensive training program
- **Process Disruption**: Phased rollout approach
- **Data Migration**: Careful planning and testing
- **Downtime**: Minimal downtime deployment strategy

## Success Metrics

### Phase 1 Success Criteria
- [ ] Development environment fully functional
- [ ] Custom app created and integrated
- [ ] Basic ERPNext functionality working
- [ ] Local testing completed

### Phase 2 Success Criteria
- [ ] All core business processes implemented
- [ ] Reports and dashboards functional
- [ ] User training completed
- [ ] System performance validated

### Phase 3 Success Criteria
- [ ] Production deployment successful
- [ ] SSL and security configured
- [ ] Backup strategy implemented
- [ ] Go-live completed successfully

## Production Data Restoration

### Backup Transfer from Contabo
```bash
# Transfer backups from Contabo server to local machine
scp user@your-contabo-server:/path/to/backups/*.tar.gz /Users/adeemadilkhatri/adnoor-erp/backups/
```

### Restore Process
```bash
# Navigate to frappe_docker directory
cd /Users/adeemadilkhatri/adnoor-erp/frappe_docker

# Restore the backup
docker compose exec backend bench --site adnoor-dev.local restore /path/to/backup.tar.gz

# Migrate to apply any necessary patches
docker compose exec backend bench --site adnoor-dev.local migrate
```

### Verification Steps (High-level)
1. **Company Information**: Verify company name, abbreviation, and settings
2. **Chart of Accounts**: Check account structure matches production
3. **Users and Roles**: Verify user accounts and permissions
4. **Items and Pricing**: Check item master and pricing data
5. **Customer/Supplier Data**: Verify master data
6. **Financial Settings**: Check currency, fiscal year, etc.

### Local vs Production Test Checklist (Detailed)
- **Authentication**
  - Login with production users that were restored
  - Password reset and email templating (simulate without sending if needed)
- **Desk and Navigation**
  - Sidebar modules available match production
  - Role-based visibility (System Manager, Accounts Manager, HR Manager, Employee)
- **Masters**
  - Customer/Supplier lists and primary fields (names, emails, tax ids)
  - Item master fields incl. UOM, valuation, default warehouse, pricing rules
- **Transactions**
  - Sales: Quotation → Sales Order → Sales Invoice → Payment Entry (draft flow)
  - Purchase: Purchase Order → Purchase Receipt/GRN → Purchase Invoice → Payment Entry
  - Stock Moves: Material Receipt/Issue/Transfer; stock ledger matches
- **Accounting**
  - Chart of Accounts structure and opening balances
  - Trial Balance, General Ledger load without errors
- **HRMS (installed to mirror prod)**
  - Employee list, basic doctype access per role
- **Files/Attachments**
  - Random document attachments open (checks public/private files restore)
- **Website/Branding**
  - Login/header/logo, favicon and splash render as configured
- **Background Jobs**
  - Scheduler running; no repeating errors in logs
- **Performance/Errors**
  - No 500/502 on main pages; backend logs clean

When defects are found, capture: module, doctype, record link, expected vs actual, and attach screenshot.

## Access Information

### Development Environment
- **URL**: https://adnoor-dev.local
- **Admin Username**: Administrator
- **Credentials**: Stored in secure secrets manager (.env/1Password/Bitwarden); not in docs or repo
- **Note**: Add `127.0.0.1 adnoor-dev.local` to `/etc/hosts` for proper access

## Next Steps

1. **Immediate (This Week) — MVP Mirror**
   - ✅ Complete development environment setup
   - ✅ **Access and verify ERPNext instance**
   - ✅ **Complete setup wizard**
   - ✅ **Restore production data from Contabo backups**
   - [ ] Custom app: postponed (configure in UI; export later if needed)
   - [ ] Run Local vs Production Test Checklist and log gaps

2. **Short Term (Next 2 Weeks)**
   - Close parity gaps found during testing (MVP sign‑off)
    - Prepare client demo and acceptance checklist
   - Set up basic reports and dashboards
   - Begin user training (admin and key roles)

## MVP Scope (Mirrored from Production)
- Authentication and role access for restored users
- Sales: Quotation → Sales Order → Sales Invoice → Payment Entry (happy path)
- Purchase: Purchase Order → Receipt/GRN → Purchase Invoice → Payment Entry
- Inventory: Item master, stock ledger view, internal transfers
- Accounting: Chart of Accounts, GL/Trial Balance load
- HRMS access parity (viewing Employee data where applicable)
- Files and attachments accessible
- Website/Login branding in place

MVP Exit Criteria: All above flows work without errors on `adnoor-dev.local`, and reports render with production data.

## Phased Roadmap (for Client)
### Phase A (2–3 weeks) — Stabilize and Parity
- Resolve parity issues, finalize dashboards/reports used daily
- Document SOPs; admin/manager training

### Phase B (4–5 weeks) — Custom Procurement Workflows
- Weekly Task Manager, Procurement Dashboard, Lead & Data Team Workflow
- Reorder and Delivery Scheduling automation

### Phase C (3–4 weeks) — Logistics/Delivery
- Dispatch module, GRN improvements, status tracking

### Phase D (3–4 weeks) — Supplier/Region Views
- Supplier portal/dashboard, regional task assignment and monitoring

### Phase E (3–4 weeks) — Telephony Integrations
- Click‑to‑Call, softphone, call logging/recording, agent analytics

### Phase F (4–6 weeks, parallel) — Mobile Apps
- Drivers app; Admin lite

### Phase G (3–4 weeks) — Smart Expansion
- POS, Barcode/QR, Vendor onboarding

3. **Medium Term (Next Month)**
   - Complete Phase 2 implementation
   - Prepare for production deployment
   - Finalize backup and monitoring strategy

4. **Long Term (Next Quarter)**
   - Production go-live
   - Post-go-live support
   - Begin Phase 4 planning

---

*Last Updated: $(date)*
*Version: 1.0*
*Status: Phase 1 - Development Environment Setup*
