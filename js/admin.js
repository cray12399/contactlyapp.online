// Local State Data
let adminData = {
  id: 1000,
  username: "AdminMaster",
  firstName: "System",
  lastName: "Admin",
  email: "admin@domain.com",
  phone: "123-456-7890"
};

// Initial default seed users with unique usernames and IDs
const initialUsers = [
  { id: 122, firstName: "Matthew", lastName: "Janke", userName: "HulkS", email: "matthulksmash04@gmail.com", phone: "", enabled: true },
  { id: 101, firstName: "Jake", lastName: "Londoner", userName: "jake_l", email: "jake.Londoner@cyber.io", phone: "407-555-0199", enabled: false },
  { id: 102, firstName: "Michelle", lastName: "Smith", userName: "msmith", email: "michelleSmith@example.com", phone: "407-555-0123", enabled: true },
  { id: 103, firstName: "Hungry", lastName: "Hippo", userName: "hhippo", email: "HHippo@ucf.edu", phone: "321-457-0144", enabled: true },
  { id: 104, firstName: "Icecream", lastName: "Mike", userName: "icemike", email: "MikeAndIkes@truck.org", phone: "407-980-0188", enabled: true },
  { id: 201, firstName: "Taylor", lastName: "Swift", userName: "tswift", email: "tSwift@fake.com", phone: "123-567-0177", enabled: true },
  { id: 202, firstName: "Famous", lastName: "Person2", userName: "famous2", email: "lol@notFamous.org", phone: "321-999-0166", enabled: false },
  { id: 203, firstName: "Alex", lastName: "Dicey", userName: "River", email: "rice@chicken.io", phone: "123-759-0155", enabled: true },
  { id: 204, firstName: "Sarah", lastName: "Barnes", userName: "sBarnes", email: "barnesAndNoble@books.com", phone: "321-000-0190", enabled: true },
  { id: 205, firstName: "David", lastName: "Eating", userName: "Taco", email: "TacoBell@theSpot.net", phone: "876-016-0142", enabled: true }
];

let usersList = [];
let filteredUsers = [];
let globalStatus = true;

// Pagination Configuration
let currentPage = 1;
const rowsPerPage = 5;

document.addEventListener("DOMContentLoaded", function () {
  loadAdminProfile();
  initUserData();
  attachInputListeners();
});

// Real-time error clearing on typing
function attachInputListeners() {
  const inputs = document.querySelectorAll("input");
  inputs.forEach(input => {
    input.addEventListener("input", function () {
      const errorDiv = document.getElementById(this.id + "Error");
      if (errorDiv) {
        this.classList.remove("is-invalid");
        errorDiv.innerText = "";
        errorDiv.style.display = "none";
      }
    });
  });
}

// Helper functions for Inline Error Messages
function setFieldError(fieldId, errorId, message) {
  const inputEl = document.getElementById(fieldId);
  const errorEl = document.getElementById(errorId);
  if (inputEl) inputEl.classList.add("is-invalid");
  if (errorEl) {
    errorEl.innerText = message;
    errorEl.style.display = "block";
  }
}

function clearFieldError(fieldId, errorId) {
  const inputEl = document.getElementById(fieldId);
  const errorEl = document.getElementById(errorId);
  if (inputEl) inputEl.classList.remove("is-invalid");
  if (errorEl) {
    errorEl.innerText = "";
    errorEl.style.display = "none";
  }
}

function validateEmail(email) {
  return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email);
}

// Flexible Phone Validation: Accepts all common formatting (e.g. (123) 456-7890, 123-456-7890, 1234567890, 123.456.7890)
function validatePhone(phone) {
  if (!phone) return true; // Optional field
  const digitsOnly = phone.replace(/\D/g, "");
  return digitsOnly.length === 10;
}

// Check for duplicate username across all users and admin
function isDuplicateUsername(username, currentUserId = null) {
  const lowerName = username.toLowerCase();

  if (adminData.id !== currentUserId && adminData.username.toLowerCase() === lowerName) {
    return true;
  }

  return usersList.some(user => {
    if (currentUserId && user.id === currentUserId) return false;
    const uName = (user.userName || user.username || '').toLowerCase();
    return uName === lowerName;
  });
}

// Load users from localStorage or initialize defaults
function initUserData() {
  const storedUsers = localStorage.getItem("app_users");
  if (storedUsers) {
    try {
      const parsed = JSON.parse(storedUsers);
      if (Array.isArray(parsed) && parsed.length > 0) {
        usersList = parsed;
      } else {
        usersList = [...initialUsers];
        saveUsersToStorage();
      }
    } catch (e) {
      console.error("Error reading localStorage:", e);
      usersList = [...initialUsers];
      saveUsersToStorage();
    }
  } else {
    usersList = [...initialUsers];
    saveUsersToStorage();
  }
  filterUsers();
}

function saveUsersToStorage() {
  localStorage.setItem("app_users", JSON.stringify(usersList));
}

// 1. Populate Admin Nav & Self Profile Info
function loadAdminProfile() {
  const navUser = document.getElementById("navAdminUsername");
  if (navUser) navUser.innerText = adminData.username;
  
  const ddId = document.getElementById("ddAdminId");
  if (ddId) ddId.innerText = adminData.id;

  const ddEmail = document.getElementById("ddAdminEmail");
  if (ddEmail) ddEmail.innerText = adminData.email;

  const ddPhone = document.getElementById("ddAdminPhone");
  if (ddPhone) ddPhone.innerText = adminData.phone;

  const selfId = document.getElementById("selfAdminId");
  if (selfId) selfId.value = adminData.id;

  const selfUn = document.getElementById("selfUsername");
  if (selfUn) selfUn.value = adminData.username;

  const selfFN = document.getElementById("selfFirstName");
  if (selfFN) selfFN.value = adminData.firstName;

  const selfLN = document.getElementById("selfLastName");
  if (selfLN) selfLN.value = adminData.lastName;

  const selfEm = document.getElementById("selfEmail");
  if (selfEm) selfEm.value = adminData.email;

  const selfPh = document.getElementById("selfPhone");
  if (selfPh) selfPh.value = adminData.phone;

  clearFieldError("selfUsername", "selfUsernameError");
  clearFieldError("selfFirstName", "selfFirstNameError");
  clearFieldError("selfLastName", "selfLastNameError");
  clearFieldError("selfEmail", "selfEmailError");
  clearFieldError("selfPhone", "selfPhoneError");
}

function saveSelfProfile() {
  let isValid = true;
  const username = document.getElementById("selfUsername").value.trim();
  const firstName = document.getElementById("selfFirstName").value.trim();
  const lastName = document.getElementById("selfLastName").value.trim();
  const email = document.getElementById("selfEmail").value.trim();
  const phone = document.getElementById("selfPhone").value.trim();

  clearFieldError("selfUsername", "selfUsernameError");
  clearFieldError("selfFirstName", "selfFirstNameError");
  clearFieldError("selfLastName", "selfLastNameError");
  clearFieldError("selfEmail", "selfEmailError");
  clearFieldError("selfPhone", "selfPhoneError");

  if (!username) {
    setFieldError("selfUsername", "selfUsernameError", "Username is required.");
    isValid = false;
  } else if (username.length <= 3) {
    setFieldError("selfUsername", "selfUsernameError", "Username must be longer than 3 characters.");
    isValid = false;
  } else if (isDuplicateUsername(username, adminData.id)) {
    setFieldError("selfUsername", "selfUsernameError", "Username is already taken.");
    isValid = false;
  }

  if (!firstName) {
    setFieldError("selfFirstName", "selfFirstNameError", "First name is required.");
    isValid = false;
  }
  if (!lastName) {
    setFieldError("selfLastName", "selfLastNameError", "Last name is required.");
    isValid = false;
  }
  if (!email) {
    setFieldError("selfEmail", "selfEmailError", "Email address is required.");
    isValid = false;
  } else if (!validateEmail(email)) {
    setFieldError("selfEmail", "selfEmailError", "Please enter a valid email address.");
    isValid = false;
  }

  if (phone && !validatePhone(phone)) {
    setFieldError("selfPhone", "selfPhoneError", "Please enter a valid 10-digit phone number.");
    isValid = false;
  }

  if (!isValid) return;

  adminData.username = username;
  adminData.firstName = firstName;
  adminData.lastName = lastName;
  adminData.email = email;
  adminData.phone = phone;

  loadAdminProfile();

  const modalEl = document.getElementById('selfProfileModal');
  const modal = bootstrap.Modal.getInstance(modalEl);
  if (modal) modal.hide();
}

// 2. Render Users Table with Pagination
function renderUserTable() {
  const tableBody = document.getElementById("userTableBody");
  if (!tableBody) return;
  tableBody.innerHTML = "";

  const totalEntries = filteredUsers.length;
  const totalPages = Math.ceil(totalEntries / rowsPerPage) || 1;

  if (currentPage > totalPages) currentPage = totalPages;
  if (currentPage < 1) currentPage = 1;

  if (totalEntries === 0) {
    tableBody.innerHTML = `<tr><td colspan="7" class="text-center py-4 text-muted">No users found.</td></tr>`;
    renderPaginationControls(0, 0, 0, 0);
    return;
  }

  const startIndex = (currentPage - 1) * rowsPerPage;
  const endIndex = Math.min(startIndex + rowsPerPage, totalEntries);
  const pageItems = filteredUsers.slice(startIndex, endIndex);

  pageItems.forEach(user => {
    const isEnabled = user.enabled !== false;
    const statusBadge = isEnabled
      ? `<span class="badge bg-success">Active</span>`
      : `<span class="badge bg-secondary">Disabled</span>`;

    const toggleBtnText = isEnabled ? "Disable" : "Enable";
    const toggleBtnClass = isEnabled ? "btn-outline-danger" : "btn-outline-success";
    const username = user.userName || user.username || 'N/A';

    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${user.id || 'N/A'}</td>
      <td>${user.firstName || ''} ${user.lastName || ''}</td>
      <td><strong>${username}</strong></td>
      <td>${user.email || 'N/A'}</td>
      <td>${user.phone || 'N/A'}</td>
      <td>${statusBadge}</td>
      <td class="text-center">
        <button class="btn btn-sm btn-outline-primary me-1" onclick="openEditUserModal(${user.id})">
          <i class="bi bi-pencil-square me-1"></i> Edit
        </button>
        <button class="btn btn-sm ${toggleBtnClass}" onclick="toggleUserStatus(${user.id})">
          <i class="bi bi-power me-1"></i> ${toggleBtnText}
        </button>
      </td>
    `;
    tableBody.appendChild(tr);
  });

  renderPaginationControls(startIndex + 1, endIndex, totalEntries, totalPages);
}

// Render Pagination Controls & Info Counter
function renderPaginationControls(start, end, total, totalPages) {
  const infoEl = document.getElementById("paginationInfo");
  const controlsEl = document.getElementById("paginationControls");

  if (infoEl) {
    infoEl.innerText = `Showing ${total === 0 ? 0 : start} to ${end} of ${total} entries`;
  }
  
  if (!controlsEl) return;
  controlsEl.innerHTML = "";

  if (totalPages <= 1) return;

  // Previous Page
  const prevLi = document.createElement("li");
  prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
  prevLi.innerHTML = `<a class="page-link" href="#" onclick="changePage(${currentPage - 1}); return false;">Previous</a>`;
  controlsEl.appendChild(prevLi);

  // Numeric Page Numbers
  for (let i = 1; i <= totalPages; i++) {
    const li = document.createElement("li");
    li.className = `page-item ${i === currentPage ? 'active' : ''}`;
    li.innerHTML = `<a class="page-link" href="#" onclick="changePage(${i}); return false;">${i}</a>`;
    controlsEl.appendChild(li);
  }

  // Next Page
  const nextLi = document.createElement("li");
  nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
  nextLi.innerHTML = `<a class="page-link" href="#" onclick="changePage(${currentPage + 1}); return false;">Next</a>`;
  controlsEl.appendChild(nextLi);
}

function changePage(page) {
  currentPage = page;
  renderUserTable();
}

// 3. Combined Live Search & Status Filtering
function filterUsers() {
  const searchInput = document.getElementById("userSearchInput");
  const statusSelect = document.getElementById("statusFilterSelect");

  const query = searchInput ? searchInput.value.toLowerCase().trim() : "";
  const statusFilter = statusSelect ? statusSelect.value : "all";

  filteredUsers = usersList.filter(user => {
    const fName = (user.firstName || '').toLowerCase();
    const lName = (user.lastName || '').toLowerCase();
    const fullName = `${fName} ${lName}`.trim();
    const uName = (user.userName || user.username || '').toLowerCase();

    const matchesQuery = !query || 
                         fName.includes(query) || 
                         lName.includes(query) || 
                         fullName.includes(query) || 
                         uName.includes(query);

    let matchesStatus = true;
    if (statusFilter === "active") {
      matchesStatus = user.enabled !== false;
    } else if (statusFilter === "disabled") {
      matchesStatus = user.enabled === false;
    }

    return matchesQuery && matchesStatus;
  });

  currentPage = 1;
  renderUserTable();
}

// 4. Toggle Individual User Account Status
function toggleUserStatus(userId) {
  const user = usersList.find(u => u.id === userId);
  if (user) {
    user.enabled = user.enabled === false ? true : false;
    saveUsersToStorage();

    // Re-filter if actively filtering by active/disabled status, otherwise stay on page
    const statusSelect = document.getElementById("statusFilterSelect");
    if (statusSelect && statusSelect.value !== "all") {
      filterUsers();
    } else {
      renderUserTable();
    }
  }
}

// 5. Global Toggle All Users
function toggleAllUsers() {
  globalStatus = !globalStatus;
  usersList.forEach(u => u.enabled = globalStatus);
  saveUsersToStorage();
  filterUsers();
}

// 6. Edit User Modal & Password Inline Validation
function openEditUserModal(userId) {
  const user = usersList.find(u => u.id === userId);
  if (!user) return;

  document.getElementById("editUserId").value = user.id;
  document.getElementById("editUsername").value = user.userName || user.username || "";
  document.getElementById("editFirstName").value = user.firstName || "";
  document.getElementById("editLastName").value = user.lastName || "";
  document.getElementById("editEmail").value = user.email || "";
  document.getElementById("editPhone").value = user.phone || "";

  clearFieldError("editUsername", "editUsernameError");
  clearFieldError("editFirstName", "editFirstNameError");
  clearFieldError("editLastName", "editLastNameError");
  clearFieldError("editEmail", "editEmailError");
  clearFieldError("editPhone", "editPhoneError");
  clearFieldError("newPassword", "newPasswordError");
  clearFieldError("confirmNewPassword", "confirmNewPasswordError");

  document.getElementById("passwordSection").classList.add("d-none");
  document.getElementById("newPassword").value = "";
  document.getElementById("confirmNewPassword").value = "";

  const modal = new bootstrap.Modal(document.getElementById('editUserModal'));
  modal.show();
}

function togglePasswordSection() {
  const section = document.getElementById("passwordSection");
  section.classList.toggle("d-none");
}

function saveNewPassword() {
  const pass = document.getElementById("newPassword").value.trim();
  const confirm = document.getElementById("confirmNewPassword").value.trim();
  let isValid = true;

  clearFieldError("newPassword", "newPasswordError");
  clearFieldError("confirmNewPassword", "confirmNewPasswordError");

  if (!pass || pass.length < 6) {
    setFieldError("newPassword", "newPasswordError", "Password must be at least 6 characters.");
    isValid = false;
  }
  if (pass !== confirm) {
    setFieldError("confirmNewPassword", "confirmNewPasswordError", "Passwords do not match.");
    isValid = false;
  }

  if (!isValid) return;

  alert("User password updated successfully!");
  document.getElementById("passwordSection").classList.add("d-none");
}

function saveUserChanges() {
  const userId = parseInt(document.getElementById("editUserId").value);
  const user = usersList.find(u => u.id === userId);

  const username = document.getElementById("editUsername").value.trim();
  const firstName = document.getElementById("editFirstName").value.trim();
  const lastName = document.getElementById("editLastName").value.trim();
  const email = document.getElementById("editEmail").value.trim();
  const phone = document.getElementById("editPhone").value.trim();
  let isValid = true;

  clearFieldError("editUsername", "editUsernameError");
  clearFieldError("editFirstName", "editFirstNameError");
  clearFieldError("editLastName", "editLastNameError");
  clearFieldError("editEmail", "editEmailError");
  clearFieldError("editPhone", "editPhoneError");

  if (!username) {
    setFieldError("editUsername", "editUsernameError", "Username is required.");
    isValid = false;
  } else if (username.length <= 3) {
    setFieldError("editUsername", "editUsernameError", "Username must be longer than 3 characters.");
    isValid = false;
  } else if (isDuplicateUsername(username, userId)) {
    setFieldError("editUsername", "editUsernameError", "Username is already taken.");
    isValid = false;
  }

  if (!firstName) {
    setFieldError("editFirstName", "editFirstNameError", "First name is required.");
    isValid = false;
  }
  if (!lastName) {
    setFieldError("editLastName", "editLastNameError", "Last name is required.");
    isValid = false;
  }
  if (!email) {
    setFieldError("editEmail", "editEmailError", "Email address is required.");
    isValid = false;
  } else if (!validateEmail(email)) {
    setFieldError("editEmail", "editEmailError", "Please enter a valid email address.");
    isValid = false;
  }

  if (phone && !validatePhone(phone)) {
    setFieldError("editPhone", "editPhoneError", "Please enter a valid 10-digit phone number.");
    isValid = false;
  }

  if (!isValid) return;

  if (user) {
    user.userName = username;
    user.username = username;
    user.firstName = firstName;
    user.lastName = lastName;
    user.email = email;
    user.phone = phone;
    saveUsersToStorage();
    renderUserTable();
  }

  const modalEl = document.getElementById('editUserModal');
  const modal = bootstrap.Modal.getInstance(modalEl);
  if (modal) modal.hide();
}

// 7. Add New Admin Inline Validation
function openAddAdminModal() {
  const nextId = usersList.length > 0 ? Math.max(...usersList.map(u => u.id || 0)) + 1 : 1001;
  document.getElementById("newAdminId").value = nextId;

  document.getElementById("newAdminUsername").value = "";
  document.getElementById("newAdminFirstName").value = "";
  document.getElementById("newAdminLastName").value = "";
  document.getElementById("newAdminEmail").value = "";
  document.getElementById("newAdminPhone").value = "";
  document.getElementById("newAdminPassword").value = "";
  document.getElementById("newAdminPasswordConfirm").value = "";

  clearFieldError("newAdminUsername", "newAdminUsernameError");
  clearFieldError("newAdminFirstName", "newAdminFirstNameError");
  clearFieldError("newAdminLastName", "newAdminLastNameError");
  clearFieldError("newAdminEmail", "newAdminEmailError");
  clearFieldError("newAdminPhone", "newAdminPhoneError");
  clearFieldError("newAdminPassword", "newAdminPasswordError");
  clearFieldError("newAdminPasswordConfirm", "newAdminPasswordConfirmError");

  const modal = new bootstrap.Modal(document.getElementById('addAdminModal'));
  modal.show();
}

function createNewAdmin() {
  const uname = document.getElementById("newAdminUsername").value.trim();
  const fName = document.getElementById("newAdminFirstName").value.trim();
  const lName = document.getElementById("newAdminLastName").value.trim();
  const email = document.getElementById("newAdminEmail").value.trim();
  const phone = document.getElementById("newAdminPhone").value.trim();
  const pass = document.getElementById("newAdminPassword").value.trim();
  const confirmPass = document.getElementById("newAdminPasswordConfirm").value.trim();
  let isValid = true;

  clearFieldError("newAdminUsername", "newAdminUsernameError");
  clearFieldError("newAdminFirstName", "newAdminFirstNameError");
  clearFieldError("newAdminLastName", "newAdminLastNameError");
  clearFieldError("newAdminEmail", "newAdminEmailError");
  clearFieldError("newAdminPhone", "newAdminPhoneError");
  clearFieldError("newAdminPassword", "newAdminPasswordError");
  clearFieldError("newAdminPasswordConfirm", "newAdminPasswordConfirmError");

  if (!uname) {
    setFieldError("newAdminUsername", "newAdminUsernameError", "Username is required.");
    isValid = false;
  } else if (uname.length <= 3) {
    setFieldError("newAdminUsername", "newAdminUsernameError", "Username must be longer than 3 characters.");
    isValid = false;
  } else if (isDuplicateUsername(uname)) {
    setFieldError("newAdminUsername", "newAdminUsernameError", "Username is already taken.");
    isValid = false;
  }

  if (!fName) {
    setFieldError("newAdminFirstName", "newAdminFirstNameError", "First name is required.");
    isValid = false;
  }
  if (!lName) {
    setFieldError("newAdminLastName", "newAdminLastNameError", "Last name is required.");
    isValid = false;
  }
  if (!email) {
    setFieldError("newAdminEmail", "newAdminEmailError", "Email address is required.");
    isValid = false;
  } else if (!validateEmail(email)) {
    setFieldError("newAdminEmail", "newAdminEmailError", "Please enter a valid email address.");
    isValid = false;
  }

  if (phone && !validatePhone(phone)) {
    setFieldError("newAdminPhone", "newAdminPhoneError", "Please enter a valid 10-digit phone number.");
    isValid = false;
  }

  if (!pass || pass.length < 6) {
    setFieldError("newAdminPassword", "newAdminPasswordError", "Password must be at least 6 characters.");
    isValid = false;
  }
  if (pass !== confirmPass) {
    setFieldError("newAdminPasswordConfirm", "newAdminPasswordConfirmError", "Passwords do not match.");
    isValid = false;
  }

  if (!isValid) return;

  const newAdminObj = {
    id: parseInt(document.getElementById("newAdminId").value),
    firstName: fName,
    lastName: lName,
    userName: uname,
    username: uname,
    email: email,
    phone: phone,
    enabled: true
  };

  usersList.push(newAdminObj);
  saveUsersToStorage();
  filterUsers();

  const modalEl = document.getElementById('addAdminModal');
  const modal = bootstrap.Modal.getInstance(modalEl);
  if (modal) modal.hide();
}

function registerUser(firstName, lastName, userName, email, phone) {
  const newUser = {
    id: usersList.length > 0 ? Math.max(...usersList.map(u => u.id || 0)) + 1 : 101,
    firstName: firstName,
    lastName: lastName,
    userName: userName,
    email: email || '',
    phone: phone || '',
    enabled: true
  };

  usersList.push(newUser);
  saveUsersToStorage();
  filterUsers();
}

// 8. Logout Confirmation Popup Flow
function openLogoutModal() {
  const logoutModal = new bootstrap.Modal(document.getElementById('logoutModal'));
  logoutModal.show();
}

function confirmLogout() {
  window.location.href = "login.html";
}