// Local Admin Session Data (retrieved from Cookie or Session Storage)
let adminData = {
  id: 0,
  username: "",
  firstName: "",
  lastName: "",
  email: "",
  phone: ""
};

let usersList = [];
let filteredUsers = [];

// Pagination Configuration
let currentPage = 1;
const rowsPerPage = 10;

document.addEventListener("DOMContentLoaded", function () {
  readAdminSession();
  fetchUsersFromApi();
  attachInputListeners();
});

// Generic Toggle Password Visibility Helper
function togglePasswordVisibility(inputId, btnEl) {
  const input = document.getElementById(inputId);
  if (!input) return;
  const icon = btnEl.querySelector("i");
  if (input.type === "password") {
    input.type = "text";
    if (icon) {
      icon.classList.remove("bi-eye");
      icon.classList.add("bi-eye-slash");
    }
  } else {
    input.type = "password";
    if (icon) {
      icon.classList.remove("bi-eye-slash");
      icon.classList.add("bi-eye");
    }
  }
}

// Dynamic Button Renderer for Toggle All
function updateToggleAllButton() {
  const btn = document.getElementById("toggleAllBtn");
  if (!btn) return;

  const regularUsers = usersList.filter(u => u.role !== 2);
  const allDisabled = regularUsers.length > 0 && regularUsers.every(u => !checkIsEnabled(u));

  if (allDisabled) {
    btn.className = "btn btn-success fw-semibold";
    btn.innerHTML = `<i class="bi bi-power me-1"></i> Enable All`;
  } else {
    btn.className = "btn btn-danger fw-semibold";
    btn.innerHTML = `<i class="bi bi-power me-1"></i> Disable All`;
  }
}

// Helper function to explicitly open the admin profile modal
function openSelfProfileModal() {
  loadAdminProfile();
  const modalEl = document.getElementById('selfProfileModal');
  if (modalEl) {
    const modal = bootstrap.Modal.getOrCreateInstance(modalEl);
    modal.show();
  }
}

// Updated Cookie Parsing Function
function readAdminSession() {
  adminData.id = 0;
  adminData.firstName = "";
  adminData.lastName = "";
  adminData.username = "";
  adminData.email = "";
  adminData.phone = "";

  const cookies = document.cookie.split(";");
  for (let c of cookies) {
    let pair = c.trim().split("=");
    if (pair.length < 2) continue;
    let key = pair[0].trim();
    let value = decodeURIComponent(pair[1].trim());

    if (key === "firstName") adminData.firstName = value;
    else if (key === "lastName") adminData.lastName = value;
    else if (key === "userId") adminData.id = parseInt(value, 10);
    else if (key === "userName") adminData.username = value;
    else if (key === "email") adminData.email = value;
    else if (key === "phone" || key === "phoneNumber") adminData.phone = value;
  }

  // Fallback to Session Storage if Cookie values are incomplete
  if (!adminData.id) {
    const storedUser = sessionStorage.getItem("user");
    if (storedUser) {
      try {
        const parsed = JSON.parse(storedUser);
        adminData.id = parsed.id || 0;
        adminData.firstName = parsed.firstName || "";
        adminData.lastName = parsed.lastName || "";
        adminData.username = parsed.userName || parsed.username || "";
        adminData.email = parsed.email || "";
        adminData.phone = parsed.phoneNumber || parsed.phone || "";
      } catch (e) {
        console.error("Error parsing session storage user:", e);
      }
    }
  }

  loadAdminProfile();
}

// Attach real-time error clearing on input change
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

// Inline Error Helpers
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

function validatePhone(phone) {
  if (!phone) return true;
  const digitsOnly = phone.replace(/\D/g, "");
  return (digitsOnly.length === 10 || digitsOnly.length === 11);
}

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

// Check helper to handle boolean / int / string representations from PHP
function checkIsEnabled(user) {
  if (user.enabled === undefined || user.enabled === null) return user.role !== 0;
  return user.enabled === true || user.enabled === 1 || user.enabled === "1";
}

// ------------------------------------------------------------------
// API CALLS & CORE LOGIC
// ------------------------------------------------------------------

// 1. Fetch Users List from Endpoint
async function fetchUsersFromApi() {
  try {
    const response = await fetch('api/getAllUsers.php');
    if (!response.ok) throw new Error('Failed to fetch user records');
    
    const data = await response.json();
    if (data.users) {
      usersList = data.users.map(u => ({
        ...u,
        phone: u.phoneNumber || u.phone || ""
      }));

      const currentAdmin = usersList.find(user => Number(user.id) === Number(adminData.id));
      if (currentAdmin) {
        adminData = {
          id: Number(currentAdmin.id),
          username: currentAdmin.userName || currentAdmin.username || "",
          firstName: currentAdmin.firstName || "",
          lastName: currentAdmin.lastName || "",
          email: currentAdmin.email || "",
          phone: currentAdmin.phoneNumber || currentAdmin.phone || ""
        };
        loadAdminProfile();
      }

      filterUsers(false);
    }
  } catch (error) {
    console.error("API Error (GetAllUsers):", error);
  }
}

// 2. Populate Admin Nav & Self Profile Info
function loadAdminProfile() {
  const navUser = document.getElementById("navAdminUsername");
  if (navUser) navUser.innerText = adminData.username || "Admin";

  const fullName = document.getElementById("ddAdminFullName");
  if (fullName) fullName.innerText = `${adminData.firstName} ${adminData.lastName}`.trim() || "N/A";

  const username = document.getElementById("ddAdminUsername");
  if (username) username.innerText = adminData.username || "N/A";

  const ddId = document.getElementById("ddAdminId");
  if (ddId) ddId.innerText = adminData.id || "N/A";

  const ddEmail = document.getElementById("ddAdminEmail");
  if (ddEmail) ddEmail.innerText = adminData.email || "N/A";

  const ddPhone = document.getElementById("ddAdminPhone");
  if (ddPhone) ddPhone.innerText = adminData.phone || "N/A";

  const selfId = document.getElementById("selfAdminId");
  if (selfId) selfId.value = adminData.id || "";

  const selfUn = document.getElementById("selfUsername");
  if (selfUn) selfUn.value = adminData.username || "";

  const selfFN = document.getElementById("selfFirstName");
  if (selfFN) selfFN.value = adminData.firstName || "";

  const selfLN = document.getElementById("selfLastName");
  if (selfLN) selfLN.value = adminData.lastName || "";

  const selfEm = document.getElementById("selfEmail");
  if (selfEm) selfEm.value = adminData.email || "";

  const selfPh = document.getElementById("selfPhone");
  if (selfPh) selfPh.value = adminData.phone || "";

  clearFieldError("selfUsername", "selfUsernameError");
  clearFieldError("selfFirstName", "selfFirstNameError");
  clearFieldError("selfLastName", "selfLastNameError");
  clearFieldError("selfEmail", "selfEmailError");
  clearFieldError("selfPhone", "selfPhoneError");
}

// Save Self Profile changes via API
async function saveSelfProfile() {
  const username = document.getElementById("selfUsername").value.trim();
  const firstName = document.getElementById("selfFirstName").value.trim();
  const lastName = document.getElementById("selfLastName").value.trim();
  const email = document.getElementById("selfEmail").value.trim();
  const phone = document.getElementById("selfPhone").value.trim();
  let isValid = true;

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

  const payload = {
    id: adminData.id,
    firstName: firstName,
    lastName: lastName,
    userName: username,
    email: email,
    phoneNumber: phone
  };

  try {
    const response = await fetch('api/updateProfile.php', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    const result = await response.json();
    if (!response.ok) throw new Error(result.error || 'Failed to update admin profile');

    adminData.username = username;
    adminData.firstName = firstName;
    adminData.lastName = lastName;
    adminData.email = email;
    adminData.phone = phone;

    loadAdminProfile();
    await fetchUsersFromApi();

    const modalEl = document.getElementById('selfProfileModal');
    const modal = bootstrap.Modal.getInstance(modalEl);
    if (modal) modal.hide();
  } catch (error) {
    setFieldError("selfEmail", "selfEmailError", error.message);
  }
}

// 3. Table Rendering & Pagination
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
    updateToggleAllButton();
    return;
  }

  const startIndex = (currentPage - 1) * rowsPerPage;
  const endIndex = Math.min(startIndex + rowsPerPage, totalEntries);
  const pageItems = filteredUsers.slice(startIndex, endIndex);

  pageItems.forEach(user => {
    const isEnabled = checkIsEnabled(user);
    const statusBadge = isEnabled
      ? `<span class="badge bg-success">Active</span>`
      : `<span class="badge bg-secondary">Disabled</span>`;

    const toggleBtnText = isEnabled ? "Disable" : "Enable";
    const toggleBtnClass = isEnabled ? "btn-outline-danger" : "btn-outline-success";
    const username = user.userName || user.username || 'N/A';
    const isAdmin = user.role === 2;

    const tr = document.createElement("tr");
    tr.innerHTML = `
      <td>${user.id || 'N/A'}</td>
      <td>${user.firstName || ''} ${user.lastName || ''} ${isAdmin ? '<span class="badge bg-primary ms-1">Admin</span>' : ''}</td>
      <td><strong>${username}</strong></td>
      <td>${user.email || 'N/A'}</td>
      <td>${user.phoneNumber || user.phone || 'N/A'}</td>
      <td>${statusBadge}</td>
      <td class="text-center">
        <button class="btn btn-sm btn-outline-primary me-1" onclick="openEditUserModal(${user.id})">
          <i class="bi bi-pencil-square me-1"></i> Edit
        </button>
        ${!isAdmin ? `
          <button class="btn btn-sm ${toggleBtnClass}" onclick="toggleUserStatus(${user.id},${!isEnabled})">
            <i class="bi bi-power me-1"></i> ${toggleBtnText}
          </button>
        ` : `<button class="btn btn-sm btn-outline-secondary" disabled>System Admin</button>`}
      </td>
    `;
    tableBody.appendChild(tr);
  });

  renderPaginationControls(startIndex + 1, endIndex, totalEntries, totalPages);
  updateToggleAllButton();
}

function renderPaginationControls(start, end, total, totalPages) {
  const infoEl = document.getElementById("paginationInfo");
  const controlsEl = document.getElementById("paginationControls");

  if (infoEl) {
    infoEl.innerText = `Showing ${total === 0 ? 0 : start} to ${end} of ${total} entries`;
  }
  
  if (!controlsEl) return;
  controlsEl.innerHTML = "";

  if (totalPages <= 1) return;

  const prevLi = document.createElement("li");
  prevLi.className = `page-item ${currentPage === 1 ? 'disabled' : ''}`;
  prevLi.innerHTML = `<a class="page-link" href="#" onclick="changePage(${currentPage - 1}); return false;">Previous</a>`;
  controlsEl.appendChild(prevLi);

  for (let i = 1; i <= totalPages; i++) {
    const li = document.createElement("li");
    li.className = `page-item ${i === currentPage ? 'active' : ''}`;
    li.innerHTML = `<a class="page-link" href="#" onclick="changePage(${i}); return false;">${i}</a>`;
    controlsEl.appendChild(li);
  }

  const nextLi = document.createElement("li");
  nextLi.className = `page-item ${currentPage === totalPages ? 'disabled' : ''}`;
  nextLi.innerHTML = `<a class="page-link" href="#" onclick="changePage(${currentPage + 1}); return false;">Next</a>`;
  controlsEl.appendChild(nextLi);
}

function changePage(page) {
  currentPage = page;
  renderUserTable();
}

// 4. Searching & Filtering
function filterUsers(resetPage = false) {
  const searchInput = document.getElementById("userSearchInput");
  const statusSelect = document.getElementById("statusFilterSelect");

  const rawQuery = searchInput ? searchInput.value.trim() : "";
  const statusFilter = statusSelect ? statusSelect.value : "all";

  // Parse prefix syntax (e.g., userID:, username:, lastName:, email:, phoneNumber:)
  let searchPrefix = "";
  let searchTerm = rawQuery.toLowerCase();

  const colonIndex = rawQuery.indexOf(":");
  if (colonIndex !== -1) {
    const prefixCandidate = rawQuery.substring(0, colonIndex).trim().toLowerCase();
    const termCandidate = rawQuery.substring(colonIndex + 1).trim().toLowerCase();

    // Map common prefix aliases
    if (["userid", "id"].includes(prefixCandidate)) {
      searchPrefix = "userid";
    } else if (["username", "user", "username:"].includes(prefixCandidate)) {
      searchPrefix = "username";
    } else if (["firstname", "first"].includes(prefixCandidate)) {
      searchPrefix = "firstname";
    } else if (["lastname", "last"].includes(prefixCandidate)) {
      searchPrefix = "lastname";
    } else if (["email"].includes(prefixCandidate)) {
      searchPrefix = "email";
    } else if (["phonenumber", "phone"].includes(prefixCandidate)) {
      searchPrefix = "phonenumber";
    }

    if (searchPrefix !== "") {
      searchTerm = termCandidate;
    }
  }

  filteredUsers = usersList.filter(user => {
    const fName = (user.firstName || '').toLowerCase();
    const lName = (user.lastName || '').toLowerCase();
    const fullName = `${fName} ${lName}`.trim();
    const uName = (user.userName || user.username || '').toLowerCase();
    const email = (user.email || '').toLowerCase();
    const phone = (user.phoneNumber || user.phone || '').toLowerCase();
    const userIdStr = (user.id !== undefined && user.id !== null) ? String(user.id).toLowerCase() : '';

    let matchesQuery = false;

    if (!rawQuery) {
      matchesQuery = true;
    } else if (searchPrefix !== "") {
      // Prefix-specific matching logic
      switch (searchPrefix) {
        case "userid":
          matchesQuery = userIdStr.includes(searchTerm);
          break;
        case "username":
          matchesQuery = uName.includes(searchTerm);
          break;
        case "firstname":
          matchesQuery = fName.includes(searchTerm);
          break;
        case "lastname":
          matchesQuery = lName.includes(searchTerm);
          break;
        case "email":
          matchesQuery = email.includes(searchTerm);
          break;
        case "phonenumber":
          matchesQuery = phone.includes(searchTerm);
          break;
        default:
          matchesQuery = true;
      }
    } else {
      // General multi-field match
      matchesQuery = fName.includes(searchTerm) || 
                     lName.includes(searchTerm) || 
                     fullName.includes(searchTerm) || 
                     uName.includes(searchTerm) ||
                     email.includes(searchTerm) ||
                     phone.includes(searchTerm) ||
                     userIdStr.includes(searchTerm);
    }

    // Status & Role Filtering
    const isEnabled = checkIsEnabled(user);
    const isAdmin = user.role === 2;
    let matchesStatus = true;

    if (statusFilter === "active") {
      matchesStatus = isEnabled;
    } else if (statusFilter === "disabled") {
      matchesStatus = !isEnabled;
    } else if (statusFilter === "admin") {
      matchesStatus = isAdmin;
    }

    return matchesQuery && matchesStatus;
  });

  if (resetPage) {
    currentPage = 1;
  }

  renderUserTable();
}

// 5. Toggle Individual User Account Status
async function toggleUserStatus(userId, targetStatus) {
  try {
    const response = await fetch('api/toggleUserStatus.php', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: userId, enabled: targetStatus })
    });

    const result = await response.json();
    if (!response.ok) throw new Error(result.error || 'Failed to update user status');

    await fetchUsersFromApi();
  } catch (error) {
    alert(error.message);
  }
}

// 6. Global Toggle All Regular Users
async function toggleAllUsers() {
  const regularUsers = usersList.filter(u => u.role !== 2);
  const allDisabled = regularUsers.length > 0 && regularUsers.every(u => !checkIsEnabled(u));
  const targetStatus = allDisabled;

  try {
    const response = await fetch('api/toggleAllUsers.php', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ enabled: targetStatus })
    });

    const result = await response.json();
    if (!response.ok) throw new Error(result.error || 'Failed to toggle all users');

    await fetchUsersFromApi();
  } catch (error) {
    alert(error.message);
  }
}

// 7. Edit User & Change Password
function openEditUserModal(userId) {
  const user = usersList.find(u => u.id === userId);
  if (!user) return;

  document.getElementById("editUserId").value = user.id;
  document.getElementById("editUsername").value = user.userName || user.username || "";
  document.getElementById("editFirstName").value = user.firstName || "";
  document.getElementById("editLastName").value = user.lastName || "";
  document.getElementById("editEmail").value = user.email || "";
  document.getElementById("editPhone").value = user.phoneNumber || user.phone || "";

  const roleSelect = document.getElementById("editUserRole");
  if (roleSelect) {
    roleSelect.value = user.role !== undefined ? user.role : 1;
  }

  clearFieldError("editUsername", "editUsernameError");
  clearFieldError("editFirstName", "editFirstNameError");
  clearFieldError("editLastName", "editLastNameError");
  clearFieldError("editEmail", "editEmailError");
  clearFieldError("editPhone", "editPhoneError");
  clearFieldError("newPassword", "newPasswordError");
  clearFieldError("confirmNewPassword", "confirmNewPasswordError");

  const successMsg = document.getElementById("passwordSuccessMessage");
  if (successMsg) successMsg.classList.add("d-none");

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

async function saveNewPassword() {
  const userId = parseInt(document.getElementById("editUserId").value, 10);
  const pass = document.getElementById("newPassword").value.trim();
  const confirm = document.getElementById("confirmNewPassword").value.trim();
  let isValid = true;

  clearFieldError("newPassword", "newPasswordError");
  clearFieldError("confirmNewPassword", "confirmNewPasswordError");

  const successMsg = document.getElementById("passwordSuccessMessage");
  if (successMsg) successMsg.classList.add("d-none");

  if (!pass || pass.length < 6) {
    setFieldError("newPassword", "newPasswordError", "Password must be at least 6 characters.");
    isValid = false;
  }
  if (pass !== confirm) {
    setFieldError("confirmNewPassword", "confirmNewPasswordError", "Passwords do not match.");
    isValid = false;
  }

  if (!isValid) return;

  try {
    const response = await fetch('api/resetPassword.php', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ userId: userId, newPassword: pass })
    });

    const result = await response.json();
    if (!response.ok) throw new Error(result.error || 'Failed to reset password');

    if (successMsg) successMsg.classList.remove("d-none");
    document.getElementById("passwordSection").classList.add("d-none");
  } catch (error) {
    setFieldError("newPassword", "newPasswordError", error.message);
  }
}

async function saveUserChanges() {
  const userId = parseInt(document.getElementById("editUserId").value, 10);
  const username = document.getElementById("editUsername").value.trim();
  const firstName = document.getElementById("editFirstName").value.trim();
  const lastName = document.getElementById("editLastName").value.trim();
  const email = document.getElementById("editEmail").value.trim();
  const phone = document.getElementById("editPhone").value.trim();
  const role = parseInt(document.getElementById("editUserRole").value, 10);
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

  const payload = {
    id: userId,
    firstName: firstName,
    lastName: lastName,
    userName: username,
    email: email,
    phoneNumber: phone,
    role: role
  };

  try {
    const response = await fetch('api/updateProfile.php', {
      method: 'PUT',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    const result = await response.json();
    if (!response.ok) throw new Error(result.error || 'Failed to update user profile');

    await fetchUsersFromApi();

    const modalEl = document.getElementById('editUserModal');
    const modal = bootstrap.Modal.getInstance(modalEl);
    if (modal) modal.hide();
  } catch (error) {
    setFieldError("editEmail", "editEmailError", error.message);
  }
}

// 8. Create Admin User via API
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

async function createNewAdmin() {
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

  const payload = {
    firstName: fName,
    lastName: lName,
    userName: uname,
    email: email,
    phoneNumber: phone,
    password: pass,
    role: 2
  };

  try {
    const response = await fetch('api/register.php', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify(payload)
    });

    const result = await response.json();
    if (!response.ok) throw new Error(result.error || 'Failed to create admin user');

    await fetchUsersFromApi();

    const modalEl = document.getElementById('addAdminModal');
    const modal = bootstrap.Modal.getInstance(modalEl);
    if (modal) modal.hide();
  } catch (error) {
    setFieldError("newAdminEmail", "newAdminEmailError", error.message);
  }
}

// 9. Logout
function openLogoutModal() {
  const logoutModal = new bootstrap.Modal(document.getElementById('logoutModal'));
  logoutModal.show();
}

function confirmLogout() {
  document.cookie = "firstName=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  document.cookie = "lastName=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  document.cookie = "userId=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  document.cookie = "userName=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  document.cookie = "email=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  document.cookie = "phoneNumber=; expires=Thu, 01 Jan 1970 00:00:00 UTC; path=/;";
  sessionStorage.clear();
  window.location.href = "login.html";
}