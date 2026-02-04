// Invoices Module
const InvoicesModule = (function() {
    // Invoice Data
    let invoices = [];
    let clients = [];
    let invoiceTemplates = [];
    
    // Initialize Module
    function init() {
        console.log('Invoices module initializing...');
        loadInvoices();
        loadClients();
        loadTemplates();
        setupEventListeners();
    }
    
    // Load Invoices
    function loadInvoices() {
        // Simulate API call
        setTimeout(() => {
            invoices = [
                {
                    id: 'INV-2023-045',
                    clientId: 1,
                    date: '2023-10-15',
                    dueDate: '2023-11-14',
                    items: [
                        { description: 'Business Laptop Pro', quantity: 2, price: 1299.99, tax: 0.1 },
                        { description: 'Technical Support (10 hours)', quantity: 10, price: 75, tax: 0.1 }
                    ],
                    status: 'paid',
                    notes: 'Thank you for your business!',
                    paymentMethod: 'bank_transfer',
                    paidDate: '2023-10-18'
                },
                {
                    id: 'INV-2023-046',
                    clientId: 2,
                    date: '2023-10-18',
                    dueDate: '2023-11-17',
                    items: [
                        { description: 'Marketing Campaign Setup', quantity: 1, price: 1500, tax: 0.1 },
                        { description: 'Content Creation', quantity: 5, price: 250, tax: 0.1 }
                    ],
                    status: 'pending',
                    notes: 'Payment due within 30 days',
                    paymentMethod: null,
                    paidDate: null
                },
                {
                    id: 'INV-2023-044',
                    clientId: 3,
                    date: '2023-10-05',
                    dueDate: '2023-11-04',
                    items: [
                        { description: 'Inventory Management Software', quantity: 1, price: 3500, tax: 0.1 }
                    ],
                    status: 'overdue',
                    notes: 'Second reminder sent',
                    paymentMethod: null,
                    paidDate: null
                }
            ];
            
            updateInvoicesUI();
        }, 500);
    }
    
    // Load Clients
    function loadClients() {
        clients = [
            { id: 1, name: 'Global Tech Solutions', email: 'billing@globaltech.com', phone: '+1 (555) 123-4567' },
            { id: 2, name: 'Marketing Pro Inc.', email: 'accounts@marketingpro.com', phone: '+1 (555) 987-6543' },
            { id: 3, name: 'Retail Plus Co.', email: 'finance@retailplus.com', phone: '+1 (555) 456-7890' },
            { id: 4, name: 'Design Studio LLC', email: 'payments@designstudio.com', phone: '+1 (555) 789-0123' }
        ];
    }
    
    // Load Templates
    function loadTemplates() {
        invoiceTemplates = [
            { id: 1, name: 'Standard Invoice', isDefault: true },
            { id: 2, name: 'Professional Services', isDefault: false },
            { id: 3, name: 'Product Sales', isDefault: false },
            { id: 4, name: 'Recurring Invoice', isDefault: false }
        ];
    }
    
    // Update Invoices UI
    function updateInvoicesUI() {
        const container = document.getElementById('invoicesContainer');
        if (!container) return;
        
        if (invoices.length === 0) {
            container.innerHTML = '<div class="alert alert-info">No invoices found. Create your first invoice!</div>';
            return;
        }
        
        let html = `
            <div class="table-responsive">
                <table class="table">
                    <thead>
                        <tr>
                            <th>Invoice #</th>
                            <th>Client</th>
                            <th>Date</th>
                            <th>Due Date</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
        `;
        
        invoices.forEach(invoice => {
            const client = clients.find(c => c.id === invoice.clientId);
            const total = calculateInvoiceTotal(invoice);
            const statusClass = getStatusClass(invoice.status);
            const clientName = client ? client.name : 'Unknown Client';
            
            html += `
                <tr>
                    <td><strong>${invoice.id}</strong></td>
                    <td>${clientName}</td>
                    <td>${BusinessPro.formatDate(invoice.date)}</td>
                    <td>${BusinessPro.formatDate(invoice.dueDate)}</td>
                    <td>${BusinessPro.formatCurrency(total)}</td>
                    <td><span class="status-badge ${statusClass}">${invoice.status}</span></td>
                    <td>
                        <div class="action-buttons">
                            <button class="btn-small" onclick="InvoicesModule.viewInvoice('${invoice.id}')">
                                <i class="fas fa-eye"></i>
                            </button>
                            <button class="btn-small" onclick="InvoicesModule.editInvoice('${invoice.id}')">
                                <i class="fas fa-edit"></i>
                            </button>
                            <button class="btn-small" onclick="InvoicesModule.sendReminder('${invoice.id}')">
                                <i class="fas fa-envelope"></i>
                            </button>
                        </div>
                    </td>
                </tr>
            `;
        });
        
        html += '</tbody></table></div>';
        container.innerHTML = html;
    }
    
    // Calculate Invoice Total
    function calculateInvoiceTotal(invoice) {
        let subtotal = 0;
        
        invoice.items.forEach(item => {
            subtotal += item.quantity * item.price;
        });
        
        // Calculate tax
        let tax = 0;
        invoice.items.forEach(item => {
            if (item.tax) {
                tax += (item.quantity * item.price) * item.tax;
            }
        });
        
        return subtotal + tax;
    }
    
    // Get Status Class
    function getStatusClass(status) {
        switch (status.toLowerCase()) {
            case 'paid': return 'status-paid';
            case 'pending': return 'status-pending';
            case 'overdue': return 'status-overdue';
            case 'draft': return 'status-draft';
            default: return 'status-pending';
        }
    }
    
    // Setup Event Listeners
    function setupEventListeners() {
        // Create invoice button
        document.addEventListener('click', function(e) {
            if (e.target.id === 'createInvoiceBtn' || e.target.closest('#createInvoiceBtn')) {
                e.preventDefault();
                showCreateInvoiceModal();
            }
            
            if (e.target.id === 'syncInvoicesBtn' || e.target.closest('#syncInvoicesBtn')) {
                e.preventDefault();
                syncInvoices();
            }
        });
        
        // Filter invoices
        document.addEventListener('click', function(e) {
            if (e.target.classList.contains('invoice-filter')) {
                e.preventDefault();
                const filter = e.target.getAttribute('data-filter');
                filterInvoices(filter);
            }
        });
    }
    
    // Show Create Invoice Modal
    function showCreateInvoiceModal() {
        const modal = document.createElement('div');
        modal.className = 'modal invoice-modal';
        modal.innerHTML = `
            <div class="modal-content" style="max-width: 800px;">
                <div class="modal-header">
                    <h3>Create New Invoice</h3>
                    <button class="close-modal">&times;</button>
                </div>
                <div class="modal-body">
                    <form id="createInvoiceForm">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Client</label>
                                <select class="form-control" id="invoiceClient" required>
                                    <option value="">Select a client</option>
                                    ${clients.map(client => 
                                        <option value="${client.id}">${client.name}</option>
                                    ).join('')}
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Invoice Date</label>
                                <input type="date" class="form-control" id="invoiceDate" required 
                                       value="${new Date().toISOString().split('T')[0]}">
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Due Date</label>
                                <input type="date" class="form-control" id="invoiceDueDate" required 
                                       value="${new Date(Date.now() + 30 * 24 * 60 * 60 * 1000).toISOString().split('T')[0]}">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Invoice Items</label>
                            <div id="invoiceItems">
                                <div class="invoice-item-row">
                                    <div class="form-row">
                                        <div class="form-group" style="flex: 2;">
                                            <input type="text" class="form-control" placeholder="Description" name="itemDescription[]">
                                        </div>
                                        <div class="form-group">
                                            <input type="number" class="form-control" placeholder="Qty" name="itemQuantity[]" min="1" value="1">
                                        </div>
                                        <div class="form-group">
                                            <input type="number" class="form-control" placeholder="Price" name="itemPrice[]" min="0" step="0.01">
                                        </div>
                                        <div class="form-group">
                                            <select class="form-control" name="itemTax[]">
                                                <option value="0">No Tax</option>
                                                <option value="0.1">10% Tax</option>
                                                <option value="0.15">15% Tax</option>
                                            </select>
                                        </div>
                                        <div class="form-group">
                                            <button type="button" class="btn btn-danger" onclick="removeInvoiceItem(this)">
                                                <i class="fas fa-trash"></i>
                                            </button>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            
                            <button type="button" class="btn btn-secondary" onclick="addInvoiceItem()">
                                <i class="fas fa-plus"></i> Add Item
                            </button>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Notes</label>
                            <textarea class="form-control" id="invoiceNotes" rows="3" 
                                      placeholder="Add any notes or terms..."></textarea>
                        </div>
                        
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary close-modal">Cancel</button>
                            <button type="submit" class="btn btn-success">Create Invoice</button>
                        </div>
                    </form>
                </div>
            </div>
        `;
        
        document.body.appendChild(modal);
        
        // Show modal
        setTimeout(() => {
            modal.classList.add('show');
        }, 10);
        
        // Form submission
        const form = modal.querySelector('#createInvoiceForm');
        form.addEventListener('submit', function(e) {
            e.preventDefault();
            createInvoice(this);
        });
        
        // Close modal handlers
        const closeBtns = modal.querySelectorAll('.close-modal');
        closeBtns.forEach(btn => {
            btn.addEventListener('click', () => {
                modal.classList.remove('show');
                setTimeout(() => {
                    document.body.removeChild(modal);
                }, 300);
            });
        });
        
        // Close on background click
        modal.addEventListener('click', (e) => {
            if (e.target === modal) {
                modal.classList.remove('show');
                setTimeout(() => {
                    document.body.removeChild(modal);
                }, 300);
            }
        });
    }
    
    // Add Invoice Item
    function addInvoiceItem() {
        const itemsContainer = document.getElementById('invoiceItems');
        if (!itemsContainer) return;
        
        const newItem = document.createElement('div');
        newItem.className = 'invoice-item-row';
        newItem.innerHTML = `
            <div class="form-row">
                <div class="form-group" style="flex: 2;">
                    <input type="text" class="form-control" placeholder="Description" name="itemDescription[]">
                </div>
                <div class="form-group">
                    <input type="number" class="form-control" placeholder="Qty" name="itemQuantity[]" min="1" value="1">
                </div>
                <div class="form-group">
                    <input type="number" class="form-control" placeholder="Price" name="itemPrice[]" min="0" step="0.01">
                </div>
                <div class="form-group">
                    <select class="form-control" name="itemTax[]">
                        <option value="0">No Tax</option>
                        <option value="0.1">10% Tax</option>
                        <option value="0.15">15% Tax</option>
                    </select>
                </div>
                <div class="form-group">
                    <button type="button" class="btn btn-danger" onclick="removeInvoiceItem(this)">
                        <i class="fas fa-trash"></i>
                    </button>
                </div>
            </div>
        `;
        
        itemsContainer.appendChild(newItem);
    }
    
    // Remove Invoice Item (global function for inline onclick)
    window.removeInvoiceItem = function(button) {
        const itemRow = button.closest('.invoice-item-row');
        if (itemRow && itemRow.parentNode.children.length > 1) {
            itemRow.remove();
        }
    };
    
    // Create Invoice
    function createInvoice(form) {
        const formData = new FormData(form);
        const clientId = parseInt(formData.get('invoiceClient'));
        const invoiceDate = formData.get('invoiceDate');
        const dueDate = formData.get('invoiceDueDate');
        const notes = formData.get('invoiceNotes');
        
        // Collect items
        const descriptions = formData.getAll('itemDescription[]');
        const quantities = formData.getAll('itemQuantity[]');
        const prices = formData.getAll('itemPrice[]');
        const taxes = formData.getAll('itemTax[]');
        
        const items = [];
        for (let i = 0; i < descriptions.length; i++) {
            if (descriptions[i] && prices[i]) {
                items.push({
                    description: descriptions[i],
                    quantity: parseFloat(quantities[i]) || 1,
                    price: parseFloat(prices[i]) || 0,
                    tax: parseFloat(taxes[i]) || 0
                });
            }
        }
        
        if (items.length === 0) {
            alert('Please add at least one item to the invoice.');
            return;
        }
        
        // Generate invoice ID
        const invoiceId = INV-${new Date().getFullYear()}-${String(invoices.length + 1).padStart(3, '0')};
        
        // Create invoice object
        const newInvoice = {
            id: invoiceId,
            clientId: clientId,
            date: invoiceDate,
            dueDate: dueDate,
            items: items,
            status: 'pending',
            notes: notes,
            paymentMethod: null,
            paidDate: null
        };
        
        // Add to invoices array
        invoices.unshift(newInvoice);
        
        // Update UI
        updateInvoicesUI();
        
        // Close modal
        const modal = form.closest('.modal');
        if (modal) {
            modal.classList.remove('show');
            setTimeout(() => {
                document.body.removeChild(modal);
            }, 300);
        }
        
        // Show success message
        alert(Invoice ${invoiceId} created successfully!);
        
        // Add notification
        if (typeof BusinessPro !== 'undefined') {
            BusinessPro.addNotification('invoice', Invoice ${invoiceId} created);
        }
    }
    
    // View Invoice
    function viewInvoice(invoiceId) {
        const invoice = invoices.find(inv => inv.id === invoiceId);
        if (!invoice) {
            alert('Invoice not found');
            return;
        }
        
        const client = clients.find(c => c.id === invoice.clientId);
        const total = calculateInvoiceTotal(invoice);
        
        // Create modal to display invoice
        const modal = document.createElement('div');
        modal.className = 'modal invoice-detail-modal';
        modal.innerHTML = `
            <div class="modal-content" style="max-width: 900px;">
                <div class="modal-header">
                    <h3>Invoice ${invoice.id}</h3>
                    <button class="close-modal">&times;</button>
                </div>
                <div class="modal-body">
                    <div class="invoice-header">
                        <div class="invoice-info">
                            <p><strong>Date:</strong> ${BusinessPro.formatDate(invoice.date)}</p>
                            <p><strong>Due Date:</strong> ${BusinessPro.formatDate(invoice.dueDate)}</p>
                            <p><strong>Status:</strong> <span class="status-badge ${getStatusClass(invoice.status)}">${invoice.status}</span></p>
                        </div>
                        
                        <div class="invoice-client">
                            <h4>Bill To:</h4>
                            <p><strong>${client ? client.name : 'Unknown Client'}</strong></p>
                            ${client ? <p>${client.email}</p><p>${client.phone}</p> : ''}
                        </div>
                    </div>
                    
                    <div class="invoice-items">
                        <table class="table">
                            <thead>
                                <tr>
