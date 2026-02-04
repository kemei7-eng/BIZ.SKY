// BusinessPro Main Application
const BusinessPro = (function() {
    // Application Configuration
    const config = {
        appName: 'BusinessPro',
        version: '1.0.0',
        apiBaseUrl: '/api',
        defaultCurrency: 'USD',
        dateFormat: 'MM/DD/YYYY',
        itemsPerPage: 10
    };
    
    // Application State
    let state = {
        user: null,
        isAuthenticated: false,
        currentView: 'overview',
        notifications: [],
        cartItems: [],
        theme: 'light'
    };
    
    // DOM Elements
    let elements = {};
    
    // Initialize Application
    function init() {
        console.log(${config.appName} v${config.version} initializing...);
        
        // Cache DOM Elements
        cacheElements();
        
        // Load User Data
        loadUserData();
        
        // Initialize Modules
        initNavigation();
        initDashboard();
        initNotifications();
        initEventListeners();
        
        // Load Initial View
        loadView(state.currentView);
        
        console.log(${config.appName} initialized successfully.);
    }
    
    // Cache DOM Elements
    function cacheElements() {
        elements = {
            mainHeader: document.getElementById('mainHeader'),
            mainNav: document.getElementById('mainNav'),
            mainContent: document.getElementById('mainContent'),
            dashboardViews: document.getElementById('dashboardViews'),
            userAccount: document.getElementById('userAccount'),
            userName: document.getElementById('userName'),
            logoutBtn: document.getElementById('logoutBtn'),
            notificationBtn: document.getElementById('notificationBtn'),
            notificationCount: document.getElementById('notificationCount'),
            notificationPanel: document.getElementById('notificationPanel')
        };
    }
    
    // Load User Data
    function loadUserData() {
        // Check localStorage for saved user data
        const savedUser = localStorage.getItem('businessProUser');
        
        if (savedUser) {
            state.user = JSON.parse(savedUser);
            state.isAuthenticated = true;
            updateUserUI();
        } else {
            // Demo user for development
            state.user = {
                id: 1,
                name: 'John Smith',
                email: 'john@example.com',
                role: 'admin',
                company: 'BusinessPro Inc.',
                avatar: null
            };
            state.isAuthenticated = true;
            localStorage.setItem('businessProUser', JSON.stringify(state.user));
            updateUserUI();
        }
    }
    
    // Update User UI
    function updateUserUI() {
        if (elements.userName && state.user) {
            elements.userName.textContent = state.user.name.split(' ')[0];
        }
    }
    
    // Initialize Navigation
    function initNavigation() {
        // Smooth scrolling for anchor links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function(e) {
                e.preventDefault();
                
                const targetId = this.getAttribute('href');
                if (targetId === '#') return;
                
                const targetElement = document.querySelector(targetId);
                if (targetElement) {
                    window.scrollTo({
                        top: targetElement.offsetTop - 80,
                        behavior: 'smooth'
                    });
                }
            });
        });
        
        // Navigation link click handlers
        document.querySelectorAll('.nav-link').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Update active nav link
                document.querySelectorAll('.nav-link').forEach(item => {
                    item.classList.remove('active');
                });
                this.classList.add('active');
                
                // Load the corresponding view
                const view = this.getAttribute('href').substring(1);
                if (view && view !== state.currentView) {
                    state.currentView = view;
                    loadView(view);
                }
            });
        });
        
        // Dashboard navigation
        document.querySelectorAll('.dashboard-nav-link').forEach(link => {
            link.addEventListener('click', function(e) {
                e.preventDefault();
                
                // Update active dashboard nav link
                document.querySelectorAll('.dashboard-nav-link').forEach(item => {
                    item.classList.remove('active');
                });
                this.classList.add('active');
                
                // Load the dashboard view
                const view = this.getAttribute('data-view');
                if (view && view !== state.currentView) {
                    state.currentView = view;
                    loadView(view);
                }
            });
        });
    }
    
    // Load View
    function loadView(viewName) {
        console.log(Loading view: ${viewName});
        
        // Clear current content
        if (elements.dashboardViews) {
            elements.dashboardViews.innerHTML = '';
        }
        
        // Load view based on name
        switch (viewName) {
            case 'overview':
                loadOverviewView();
                break;
            case 'products':
                loadProductsView();
                break;
            case 'invoices':
                loadInvoicesView();
                break;
            case 'receivables':
                loadReceivablesView();
                break;
            case 'expenses':
                loadExpensesView();
                break;
            case 'reports':
                loadReportsView();
                break;
            default:
                loadOverviewView();
        }
        
        // Update URL hash
        window.location.hash = viewName;
    }
    
    // Load Overview View
    function loadOverviewView() {
        if (!elements.dashboardViews) return;
        
        elements.dashboardViews.innerHTML = `
            <div class="dashboard-view" id="overviewView">
                <h2>Financial Overview</h2>
                <p class="subtitle">Track your money inflow, expenses, and profit in real-time</p>
                
                <div class="financial-overview">
                    <div class="financial-card income">
                        <h3>Total Income</h3>
                        <div class="amount">$42,580</div>
                        <div class="trend"><i class="fas fa-arrow-up"></i> 12% from last month</div>
                    </div>
                    
                    <div class="financial-card expenses">
                        <h3>Total Expenses</h3>
                        <div class="amount">$18,250</div>
                        <div class="trend"><i class="fas fa-arrow-down"></i> 5% from last month</div>
                    </div>
                    
                    <div class="financial-card receivables">
                        <h3>Outstanding Receivables</h3>
                        <div class="amount">$12,430</div>
                        <div class="trend"><i class="fas fa-exclamation-circle"></i> 3 invoices overdue</div>
                    </div>
                    
                    <div class="financial-card profit">
                        <h3>Net Profit</h3>
                        <div class="amount">$24,330</div>
                        <div class="trend"><i class="fas fa-arrow-up"></i> 18% from last month</div>
                    </div>
                </div>
                
                <div id="chartsContainer"></div>
            </div>
        `;
        
        // Initialize charts
        if (typeof ChartsModule !== 'undefined') {
            ChartsModule.initOverviewCharts();
        }
    }
    
    // Load Products View
    function loadProductsView() {
        if (!elements.dashboardViews) return;
        
        elements.dashboardViews.innerHTML = `
            <div class="dashboard-view" id="productsView">
                <div class="card">
                    <div class="card-header">
                        <h3>Product Management</h3>
                        <button class="btn" id="addProductBtn">
                            <i class="fas fa-plus"></i> Add Product
                        </button>
                    </div>
                    
                    <div class="view-options">
                        <button class="view-btn active">All Products</button>
                        <button class="view-btn">In Stock</button>
                        <button class="view-btn">Out of Stock</button>
                        <button class="view-btn">Best Sellers</button>
                    </div>
                    
                    <div id="productsContainer">
                        <p>Loading products...</p>
                    </div>
                </div>
            </div>
        `;
        
        // Load products
        if (typeof ProductsModule !== 'undefined') {
            ProductsModule.loadProducts();
        }
    }
    
    // Load Invoices View
    function loadInvoicesView() {
        if (!elements.dashboardViews) return;
        
        elements.dashboardViews.innerHTML = `
            <div class="dashboard-view" id="invoicesView">
                <div class="card">
                    <div class="card-header">
                        <h3>Invoice Management</h3>
                        <div>
                            <button class="btn" id="createInvoiceBtn">
                                <i class="fas fa-plus"></i> Create Invoice
                            </button>
                            <button class="btn btn-secondary" id="syncInvoicesBtn">
                                <i class="fas fa-sync"></i> Sync Now
                            </button>
                        </div>
                    </div>
                    
                    <div class="sync-section">
                        <h4><i class="fas fa-sync-alt"></i> Sync Invoices</h4>
                        <p>Automatically sync invoices with your accounting software</p>
                        <div class="sync-options">
                            <button class="sync-btn"><i class="fas fa-cloud"></i> QuickBooks</button>
                            <button class="sync-btn"><i class="fas fa-file-excel"></i> Import CSV</button>
                            <button class="sync-btn"><i class="fas fa-plus"></i> Manual Entry</button>
                        </div>
                    </div>
                    
                    <div id="invoicesContainer">
                        <p>Loading invoices...</p>
                    </div>
                </div>
            </div>
        `;
        
        // Load invoices
        if (typeof InvoicesModule !== 'undefined') {
            InvoicesModule.loadInvoices();
        }
    }
    
    // Load other views similarly...
    
    // Initialize Dashboard
    function initDashboard() {
        // Dashboard initialization logic
        console.log('Dashboard initialized');
    }
    
    // Initialize Notifications
    function initNotifications() {
        // Load notifications from localStorage or API
        const savedNotifications = localStorage.getItem('businessProNotifications');
        
        if (savedNotifications) {
            state.notifications = JSON.parse(savedNotifications);
        } else {
            // Demo notifications
            state.notifications = [
                { id: 1, type: 'invoice', message: 'Invoice #INV-2023-046 is overdue', date: '2023-10-20', read: false },
                { id: 2, type: 'payment', message: 'Payment received from Global Tech Solutions', date: '2023-10-19', read: false },
                { id: 3, type: 'reminder', message: 'Reminder sent for Invoice #INV-2023-044', date: '2023-10-18', read: true },
                { id: 4, type: 'system', message: 'System backup completed successfully', date: '2023-10-17', read: true },
                { id: 5, type: 'alert', message: 'Low stock alert for Product #P-102', date: '2023-10-16', read: false }
            ];
            localStorage.setItem('businessProNotifications', JSON.stringify(state.notifications));
        }
        
        updateNotificationCount();
    }
    
    // Update Notification Count
    function updateNotificationCount() {
        if (!elements.notificationCount) return;
        
        const unreadCount = state.notifications.filter(n => !n.read).length;
        elements.notificationCount.textContent = unreadCount;
        elements.notificationCount.style.display = unreadCount > 0 ? 'flex' : 'none';
    }
    
    // Initialize Event Listeners
    function initEventListeners() {
        // Logout button
        if (elements.logoutBtn) {
            elements.logoutBtn.addEventListener('click', handleLogout);
        }
        
        // Notification button
        if (elements.notificationBtn) {
            elements.notificationBtn.addEventListener('click', showNotifications);
        }
        
        // User account
        if (elements.userAccount) {
            elements.userAccount.addEventListener('click', showUserProfile);
        }
    }
    
    // Handle Logout
    function handleLogout(e) {
        e.preventDefault();
        
        if (confirm('Are you sure you want to logout?')) {
            // Clear user data
            localStorage.removeItem('businessProUser');
            localStorage.removeItem('businessProAuthToken');
            
            // Redirect to login page (in a real app)
            alert('Logged out successfully. In a real app, this would redirect to login page.');
            
            // Reset state
            state.user = null;
            state.isAuthenticated = false;
            updateUserUI();
        }
    }
    
    // Show Notifications
    function showNotifications(e) {
        e.preventDefault();
        e.stopPropagation();
        
        if (!elements.notificationPanel) return;
        
        // Toggle notification panel
        const isVisible = elements.notificationPanel.style.display === 'block';
        elements.notificationPanel.style.display = isVisible ? 'none' : 'block';
        
        if (!isVisible) {
            renderNotifications();
        }
    }
    
    // Render Notifications
    function renderNotifications() {
        if (!elements.notificationPanel) return;
        
        let notificationsHTML = `
            <div class="notification-header">
                <h3>Notifications</h3>
                <button class="btn-small" id="markAllRead">Mark All Read</button>
            </div>
            <div class="notification-list">
        `;
        
        if (state.notifications.length === 0) {
            notificationsHTML += <p class="no-notifications">No notifications</p>;
        } else {
            state.notifications.forEach(notification => {
                let icon = 'fas fa-bell';
                let color = 'var(--secondary-color)';
                
                switch (notification.type) {
                    case 'invoice': icon = 'fas fa-file-invoice'; color = 'var(--warning-color)'; break;
                    case 'payment': icon = 'fas fa-money-check-alt'; color = 'var(--success-color)'; break;
                    case 'reminder': icon = 'fas fa-clock'; color = 'var(--info-color)'; break;
                    case 'alert': icon = 'fas fa-exclamation-triangle'; color = 'var(--danger-color)'; break;
                }
                
                notificationsHTML += `
                    <div class="notification-item ${notification.read ? 'read' : 'unread'}" data-id="${notification.id}">
                        <div class="notification-icon" style="color: ${color};">
                            <i class="${icon}"></i>
                        </div>
                        <div class="notification-content">
                            <p class="notification-message">${notification.message}</p>
                            <span class="notification-date">${formatDate(notification.date)}</span>
                        </div>
                        ${!notification.read ? '<span class="notification-dot"></span>' : ''}
                    </div>
                `;
            });
        }
        
        notificationsHTML += </div>;
        elements.notificationPanel.innerHTML = notificationsHTML;
        
        // Add event listeners to notification items
        document.querySelectorAll('.notification-item').forEach(item => {
            item.addEventListener('click', function() {
                const notificationId = parseInt(this.getAttribute('data-id'));
                markNotificationAsRead(notificationId);
            });
        });
        
        // Mark all as read button
        const markAllReadBtn = document.getElementById('markAllRead');
        if (markAllReadBtn) {
            markAllReadBtn.addEventListener('click', function(e) {
                e.stopPropagation();
                markAllNotificationsAsRead();
            });
        }
    }
    
    // Mark Notification as Read
    function markNotificationAsRead(notificationId) {
        const notification = state.notifications.find(n => n.id === notificationId);
        if (notification && !notification.read) {
            notification.read = true;
            localStorage.setItem('businessProNotifications', JSON.stringify(state.notifications));
            updateNotificationCount();
            renderNotifications();
        }
    }
    
    // Mark All Notifications as Read
    function markAllNotificationsAsRead() {
        let changed = false;
        
        state.notifications.forEach(notification => {
            if (!notification.read) {
                notification.read = true;
                changed = true;
            }
        });
        
        if (changed) {
            localStorage.setItem('businessProNotifications', JSON.stringify(state.notifications));
            updateNotificationCount();
            renderNotifications();
        }
    }
    
    // Show User Profile
    function showUserProfile(e) {
        e.preventDefault();
        
        // Create profile modal
        const profileModal = document.createElement('div');
        profileModal.className = 'modal profile-modal';
        profileModal.innerHTML = `
            <div class="modal-content">
                <div class="modal-header">
                    <h3>User Profile</h3>
                    <button class="close-modal">&times;</button>
                </div>
                <div class="modal-body">
                    ${state.user ? `
                        <div class="profile-info">
                            <div class="profile-avatar">
                                <i class="fas fa-user-circle"></i>
                            </div>
                            <div class="profile-details">
                                <h4>${state.user.name}</h4>
                                <p>${state.user.email}</p>
                                <p><strong>Company:</strong> ${state.user.company}</p>
                                <p><strong>Role:</strong> ${state.user.role}</p>
                            </div>
                        </div>
                        <div class="profile-actions">
                            <button class="btn">Edit Profile</button>
                            <button class="btn btn-secondary">Change Password</button>
                        </div>
                    ` : '<p>No user data available.</p>'}
                </div>
