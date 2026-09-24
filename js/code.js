const apiHost = (typeof window !== 'undefined' && window.location && (
  window.location.hostname === 'localhost' || 
  window.location.hostname === '127.0.0.1' || 
  window.location.hostname.includes('contactlyapp.online')
))
  ? '/api'
  : 'https://contactlyapp.online/api';

const loginUrlBase = `${apiHost}/login.php`;
const registerUrlBase = `${apiHost}/register.php`;
const checkUsernameUrlBase = `${apiHost}/checkUsername.php`;
const updateProfileUrlBase = `${apiHost}/updateProfile.php`;
const searchContactsUrlBase = `${apiHost}/contacts.php`;
const addContactUrlBase = `${apiHost}/addContact.php`;
const updateContactUrlBase = `${apiHost}/updateContact.php`;
const deleteContactUrlBase = `${apiHost}/deleteContact.php`;

let userId = 0;
let firstName = "";
let lastName = "";
let userEmail = "";
let userPhone = "";
let userName = "";
let userRole = 1; // Default to normal user (1)

// Global variables to preserve Step 1 inputs for sign up
let step1Username = "";
let step1Password = "";

// Initialized with realistic dummy contacts for local front-end testing
let allContacts = [
  { id: 101, firstName: "Jake", lastName: "Londoner", email: "jake.Londoner@cyber.io", phoneNumber: "407-555-0199" },
  { id: 102, firstName: "Michelle", lastName: "Smith", email: "michelleSmith@example.com", phoneNumber: "407-555-0123" },
  { id: 103, firstName: "Hungry", lastName: "Hippo", email: "HHippo@ucf.edu", phoneNumber: "321-457-0144" },
  { id: 104, firstName: "Icecream", lastName: "Mike", email: "MikeAndIkes@truck.org", phoneNumber: "407-980-0188" }
];

// Initialized with suggested mutual contacts for local front-end testing
let mutualContacts = [
  { id: 201, name: "Taylor Swift", firstName: "Taylor", lastName: "Swift", email: "tSwift@fake.com", phone: "123-567-0177", mutualsCount: 4 },
  { id: 202, name: "Famous Person2", firstName: "Famous", lastName: "Person2", email: "lol@notFamous.org", phone: "321-999-0166", mutualsCount: 2 }
];

// Helper to toggle password input visibility
function togglePasswordVisibility(inputId, iconId) {
  const passwordInput = document.getElementById(inputId);
  const icon = document.getElementById(iconId);

  if (!passwordInput || !icon) return;

  if (passwordInput.type === "password") {
    passwordInput.type = "text";
    icon.classList.remove("bi-eye-slash");
    icon.classList.add("bi-eye");
  } else {
    passwordInput.type = "password";
    icon.classList.remove("bi-eye");
    icon.classList.add("bi-eye-slash");
  }
}

// Helper to reset inline error fields across signup steps
function clearSignUpErrors() {
  const errorIds = [
    'usernameError', 'passwordError', 'confirmPasswordError',
    'firstNameError', 'lastNameError', 'emailError', 'phoneError', 'signupResult'
  ];
  errorIds.forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = "";
  });
}

function goToStep1() {
  clearSignUpErrors();
  document.getElementById('signupStep2').classList.add('d-none');
  document.getElementById('signupStep1').classList.remove('d-none');
}

async function goToStep2() {
  clearSignUpErrors();

  const usernameInput = document.getElementById('signupUsername');
  const passwordInput = document.getElementById('signupPassword');
  const confirmPasswordInput = document.getElementById('signupPasswordConfirm');

  const username = usernameInput ? usernameInput.value.trim() : "";
  const password = passwordInput ? passwordInput.value.trim() : "";
  const confirmPassword = confirmPasswordInput ? confirmPasswordInput.value.trim() : "";

  let isValid = true;

  if (!username) {
    const usernameError = document.getElementById('usernameError');
    if (usernameError) usernameError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username is required";
    isValid = false;
  } else if (username.length <= 3) {
    const usernameError = document.getElementById('usernameError');
    if (usernameError) usernameError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username must be longer than 3 characters";
    isValid = false;
  }

  if (!password) {
    const passwordError = document.getElementById('passwordError');
    if (passwordError) passwordError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Password is required";
    isValid = false;
  } else if (password.length <= 5) {
    const passwordError = document.getElementById('passwordError');
    if (passwordError) passwordError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Password must be longer than 5 characters";
    isValid = false;
  }

  if (!confirmPassword) {
    const confirmPasswordError = document.getElementById('confirmPasswordError');
    if (confirmPasswordError) confirmPasswordError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Please retype your password";
    isValid = false;
  } else if (password && password !== confirmPassword) {
    const confirmPasswordError = document.getElementById('confirmPasswordError');
    if (confirmPasswordError) confirmPasswordError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Passwords do not match";
    isValid = false;
  }

  if (!isValid) return;

  try {
    const response = await fetch(`${checkUsernameUrlBase}?username=${encodeURIComponent(username)}`, {
      method: 'GET'
    });

    if (response.ok) {
      const data = await response.json();
      if (data.available === false) {
        const usernameError = document.getElementById('usernameError');
        if (usernameError) {
          usernameError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username already in use";
        }
        return;
      }
    }
  } catch (err) {}

  step1Username = username;
  step1Password = password;

  document.getElementById('signupStep1').classList.add('d-none');
  document.getElementById('signupStep2').classList.remove('d-none');
}

function doSignUp() {
  clearSignUpErrors();

  let emailInput = document.getElementById("signupEmail");
  let firstNameInput = document.getElementById("signupFirstName");
  let lastNameInput = document.getElementById("signupLastName");
  let phoneInput = document.getElementById("signupPhone");

  let email = emailInput ? emailInput.value.trim() : "";
  let fName = firstNameInput ? firstNameInput.value.trim() : "";
  let lName = lastNameInput ? lastNameInput.value.trim() : "";
  let phone = phoneInput ? phoneInput.value.trim() : "";

  if (!step1Username || !step1Password) {
    goToStep1();
    return;
  }

  let isValid = true;

  if (!fName) {
    const firstNameError = document.getElementById('firstNameError');
    if (firstNameError) firstNameError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> First name is required";
    isValid = false;
  }

  if (!lName) {
    const lastNameError = document.getElementById('lastNameError');
    if (lastNameError) lastNameError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Last name is required";
    isValid = false;
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!email) {
    const emailError = document.getElementById('emailError');
    if (emailError) emailError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Email is required";
    isValid = false;
  } else if (!emailRegex.test(email)) {
    const emailError = document.getElementById('emailError');
    if (emailError) emailError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Invalid email format (contact@domain.ext)";
    isValid = false;
  }

  const phoneRegex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4}$/;
  if (phone !== "" && !phoneRegex.test(phone)) {
    const phoneError = document.getElementById('phoneError');
    if (phoneError) phoneError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Invalid phone number format (123-456-7890)";
    isValid = false;
  }

  if (!isValid) return;

  let jsonPayload = JSON.stringify({
    firstName: fName,
    lastName: lName,
    userName: step1Username,
    password: step1Password,
    email: email,
    phoneNumber: phone,
    phone: phone
  });

  let xhr = new XMLHttpRequest();
  xhr.open("POST", registerUrlBase, true);
  xhr.setRequestHeader("Content-type", "application/json; charset=UTF-8");

  try {
    xhr.onreadystatechange = function () {
      if (this.readyState === 4) {
        if (this.status === 200 || this.status === 201) {
          window.location.href = "login.html";
        } else {
          try {
            let jsonObject = JSON.parse(xhr.responseText);
            let errText = (jsonObject.error || "").toLowerCase();

            // Check for duplicate email error first so it displays on Step 2
            if (errText.includes("email") || errText.includes("duplicate") || errText.includes("already exists")) {
              const emailError = document.getElementById('emailError');
              if (emailError) emailError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Email already in use";
            } else if (errText.includes("username")) {
              goToStep1();
              const usernameError = document.getElementById('usernameError');
              if (usernameError) usernameError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username already in use";
            } else {
              const signupResult = document.getElementById('signupResult');
              if (signupResult) signupResult.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> " + (jsonObject.error || "Sign up failed");
            }
          } catch (e) {
            const signupResult = document.getElementById('signupResult');
            if (signupResult) signupResult.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Registration failed";
          }
        }
      }
    };
    xhr.send(jsonPayload);
  } catch (err) {
    const signupResult = document.getElementById('signupResult');
    if (signupResult) signupResult.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> " + err.message;
  }
}

function doLogin() {
  userId = 0;
  firstName = "";
  lastName = "";

  let loginInput = document.getElementById("loginName");
  let passwordInput = document.getElementById("loginPassword");
  let login = loginInput ? loginInput.value.trim() : "";
  let password = passwordInput ? passwordInput.value.trim() : "";

  let usernameError = document.getElementById("usernameError");
  let passwordError = document.getElementById("passwordError");
  let loginResult = document.getElementById("loginResult");
  let forgotResult = document.getElementById("forgotResult");

  if (usernameError) usernameError.innerHTML = "";
  if (passwordError) passwordError.innerHTML = "";
  if (loginResult) loginResult.innerHTML = "";
  if (forgotResult) forgotResult.innerHTML = "";

  let isValid = true;

  if (login === "") {
    if (usernameError) {
      usernameError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username is required";
    }
    isValid = false;
  }

  if (password === "") {
    if (passwordError) {
      passwordError.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Password is required";
    }
    isValid = false;
  }

  if (!isValid) return;

  let jsonPayload = JSON.stringify({ login: login, password: password });

  let xhr = new XMLHttpRequest();
  xhr.open("POST", loginUrlBase, true);
  xhr.setRequestHeader("Content-type", "application/json; charset=UTF-8");

  try {
    xhr.onreadystatechange = function () {
      if (this.readyState === 4) {
        if (this.status === 200) {
          try {
            let jsonObject = JSON.parse(xhr.responseText);
            let userObj = jsonObject.user || jsonObject;

            userId = userObj.id || userObj.userID || 0;

            if (userId < 1) {
              if (loginResult) {
                loginResult.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username or Password is Incorrect";
              }
              return;
            }

            firstName = userObj.firstName || "";
            lastName = userObj.lastName || "";
            userName = userObj.userName || login;
            userEmail = userObj.email || "";
            userPhone = userObj.phoneNumber || userObj.phone || "";
            userRole = userObj.role !== undefined ? parseInt(userObj.role) : 1;

            if (userRole === 0) {
              if (loginResult) {
                loginResult.innerHTML = "<div class='alert alert-danger mt-2 p-2'>Your account has been disabled. Contact 407-823-5117 if you have any questions!</div>";
              }
              return;
            }

            saveCookie();

            if (userRole === 2) {
              window.location.href = "admin.html";
            } else {
              window.location.href = "contact.html";
            }

          } catch (e) {
            if (loginResult) {
              loginResult.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username or Password is Incorrect";
            }
          }
        } else {
          if (loginResult) {
            loginResult.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username or Password is Incorrect";
          }
        }
      }
    };
    xhr.send(jsonPayload);
  } catch (err) {
    if (loginResult) {
      loginResult.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> " + err.message;
    }
  }
}

function forgotCredentials() {
  let forgotResult = document.getElementById("forgotResult");
  let loginResult = document.getElementById("loginResult");

  if (loginResult) loginResult.innerHTML = "";

  if (forgotResult) {
    forgotResult.innerHTML = "<i class='bi bi-telephone-fill me-1'></i> Contact 407-823-5117 to change your password";
  }
}

function saveCookie() {
  let minutes = 20;
  let date = new Date();
  date.setTime(date.getTime() + minutes * 60 * 1000);
  document.cookie =
    "firstName=" + encodeURIComponent(firstName) +
    ",lastName=" + encodeURIComponent(lastName) +
    ",userName=" + encodeURIComponent(userName) +
    ",email=" + encodeURIComponent(userEmail) +
    ",phone=" + encodeURIComponent(userPhone) +
    ",role=" + userRole +
    ",userId=" + userId +
    ";expires=" + date.toGMTString() +
    ";path=/";
}

function readCookie() {
  userId = -1;
  let data = document.cookie;
  let splits = data.split(";");
  
  for (var i = 0; i < splits.length; i++) {
    let pair = splits[i].trim();
    let tokens = pair.split(",");
    for (var j = 0; j < tokens.length; j++) {
      let keyVal = tokens[j].trim().split("=");
      if (keyVal[0] === "firstName") {
        firstName = decodeURIComponent(keyVal[1] || "");
      } else if (keyVal[0] === "lastName") {
        lastName = decodeURIComponent(keyVal[1] || "");
      } else if (keyVal[0] === "userId") {
        userId = parseInt(keyVal[1].trim());
      } else if (keyVal[0] === "userName") {
        userName = decodeURIComponent(keyVal[1] || "");
      } else if (keyVal[0] === "email") {
        userEmail = decodeURIComponent(keyVal[1] || "");
      } else if (keyVal[0] === "phone") {
        userPhone = decodeURIComponent(keyVal[1] || "");
      } else if (keyVal[0] === "role") {
        userRole = parseInt(keyVal[1].trim());
      }
    }
  }

  if (userId < 0 || isNaN(userId)) {
    window.location.href = "landing.html";
  } else if (userRole === 2 && !window.location.pathname.endsWith("admin.html")) {
    window.location.href = "admin.html";
  } else {
    const navUsername = document.getElementById("navUsername");
    if (navUsername) navUsername.innerText = userName || `${firstName}`;

    const dropdownFullName = document.getElementById("dropdownFullName");
    if (dropdownFullName) dropdownFullName.innerText = `${firstName} ${lastName}`;

    const dropdownUsername = document.getElementById("dropdownUsername");
    if (dropdownUsername) dropdownUsername.innerText = userName || "N/A";

    const dropdownUserId = document.getElementById("dropdownUserId");
    if (dropdownUserId) dropdownUserId.innerText = userId;

    const dropdownEmail = document.getElementById("dropdownEmail");
    if (dropdownEmail) dropdownEmail.innerText = userEmail || "Not provided";

    const dropdownPhone = document.getElementById("dropdownPhone");
    if (dropdownPhone) dropdownPhone.innerText = userPhone || "Not provided";

    fetchContacts();
    loadMutualContacts();
  }
}

// Helper: Formats phone numbers to 123-456-7890 if valid 10 digits
function formatPhoneNumber(phoneStr) {
  if (!phoneStr) return "";
  const digits = phoneStr.replace(/\D/g, "");
  if (digits.length !== 10) {
    return null;
  }
  return `${digits.slice(0, 3)}-${digits.slice(3, 6)}-${digits.slice(6)}`;
}

// Helper: Resets inline error messages for contact modals
function clearContactErrors(prefix) {
  const errorIds = [
    `${prefix}FirstNameError`,
    `${prefix}LastNameError`,
    `${prefix}EmailError`,
    `${prefix}PhoneError`
  ];
  errorIds.forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = "";
  });
}

function fetchContacts() {
  const searchInput = document.getElementById("searchText");
  const query = searchInput ? searchInput.value.trim() : "";

  if (query === "") {
    renderContacts(allContacts);
  } else {
    filterContacts();
  }
}

function openAddContactModal() {
  clearContactErrors('add');

  document.getElementById("addFirstName").value = "";
  document.getElementById("addLastName").value = "";
  document.getElementById("addEmail").value = "";
  document.getElementById("addPhone").value = "";

  let modal = new bootstrap.Modal(document.getElementById('addContactModal'));
  modal.show();
}

function saveNewContact() {
  clearContactErrors('add');

  const firstNameInput = document.getElementById("addFirstName").value.trim();
  const lastNameInput = document.getElementById("addLastName").value.trim();
  const emailInput = document.getElementById("addEmail").value.trim();
  const phoneInput = document.getElementById("addPhone").value.trim();

  let isValid = true;

  if (!firstNameInput) {
    const el = document.getElementById("addFirstNameError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> First name is required";
    isValid = false;
  }

  if (!lastNameInput) {
    const el = document.getElementById("addLastNameError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Last name is required";
    isValid = false;
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (emailInput !== "" && !emailRegex.test(emailInput)) {
    const el = document.getElementById("addEmailError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Invalid email format (contact@domain.ext)";
    isValid = false;
  }

  let formattedPhone = "";
  if (phoneInput !== "") {
    formattedPhone = formatPhoneNumber(phoneInput);
    if (!formattedPhone) {
      const el = document.getElementById("addPhoneError");
      if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Invalid phone number format (123-456-7890)";
      isValid = false;
    }
  }

  if (!isValid) return;

  const newContact = {
    id: Date.now(),
    firstName: firstNameInput,
    lastName: lastNameInput,
    email: emailInput,
    phoneNumber: formattedPhone || phoneInput
  };

  allContacts.push(newContact);

  const modalEl = document.getElementById('addContactModal');
  const modal = bootstrap.Modal.getInstance(modalEl);
  if (modal) modal.hide();

  fetchContacts();
}

function filterContacts() {
  const searchInput = document.getElementById("searchText");
  const query = searchInput ? searchInput.value.toLowerCase().trim() : "";

  let filteredContacts = allContacts.filter(contact => {
    const fName = (contact.firstName || '').toLowerCase();
    const lName = (contact.lastName || '').toLowerCase();
    const fullName = `${fName} ${lName}`.trim();

    const email = (contact.email || '').toLowerCase();
    const phone = (contact.phoneNumber || contact.phone || '').toLowerCase();

    return !query || 
           fName.includes(query) || 
           lName.includes(query) || 
           fullName.includes(query) || 
           email.includes(query) || 
           phone.includes(query);
  });

  renderContacts(filteredContacts);
}

function handleSearchInput() {
  const searchInput = document.getElementById("searchText");
  const clearBtn = document.getElementById("clearSearchBtn");
  const query = searchInput ? searchInput.value.trim() : "";

  if (clearBtn) {
    clearBtn.style.display = query.length > 0 ? "block" : "none";
  }

  fetchContacts();
}

function clearSearch() {
  const searchInput = document.getElementById("searchText");
  const clearBtn = document.getElementById("clearSearchBtn");
  
  if (searchInput) searchInput.value = "";
  if (clearBtn) clearBtn.style.display = "none";
  
  fetchContacts();
}

function renderContacts(contactsArray) {
  const contactList = document.getElementById("contactList");
  const badge = document.getElementById("contactCountBadge");

  if (!contactList) return;
  if (badge) badge.innerText = contactsArray.length;

  if (contactsArray.length === 0) {
    contactList.innerHTML = `
      <div class="col-12 text-center py-5 text-muted">
        <i class="bi bi-search display-4 d-block mb-2 text-secondary opacity-50"></i>
        <h6 class="fw-semibold">No contacts found matching your search.</h6>
      </div>
    `;
    return;
  }

  let html = "";
  contactsArray.forEach(c => {
    const phoneVal = c.phoneNumber || c.phone || 'No phone';
    html += `
      <div class="col-md-6">
        <div class="card contact-card shadow-sm p-3">
          <div class="d-flex align-items-center gap-3">
            <i class="bi bi-person-circle fs-1 text-primary"></i>
            <div class="flex-grow-1 overflow-hidden">
              <h6 class="fw-bold mb-1 text-truncate">${c.firstName} ${c.lastName}</h6>
              <small class="text-muted d-block text-truncate"><i class="bi bi-envelope me-1"></i>${c.email || 'No email'}</small>
              <small class="text-muted d-block text-truncate"><i class="bi bi-telephone me-1"></i>${phoneVal}</small>
            </div>
            
            <div class="d-flex gap-1">
              <button class="btn btn-sm btn-outline-primary border-0 action-btn" title="View / Edit Contact" onclick="openViewContactModal(${c.id})">
                <i class="bi bi-eye-fill fs-5"></i>
              </button>
              <button class="btn btn-sm btn-outline-danger border-0 action-btn" title="Remove Contact" onclick="openDeleteModal(${c.id}, '${c.firstName} ${c.lastName}')">
                <i class="bi bi-trash-fill fs-5"></i>
              </button>
            </div>

          </div>
        </div>
      </div>
    `;
  });

  contactList.innerHTML = html;
}

function openViewContactModal(contactId) {
  const contact = allContacts.find(c => c.id === contactId);
  if (!contact) return;

  clearContactErrors('edit');

  document.getElementById("editContactId").value = contact.id;
  document.getElementById("editFirstName").value = contact.firstName || "";
  document.getElementById("editLastName").value = contact.lastName || "";
  document.getElementById("editEmail").value = contact.email || "";
  document.getElementById("editPhone").value = contact.phoneNumber || contact.phone || "";
  
  document.getElementById("viewModalTitle").innerText = `Edit ${contact.firstName} ${contact.lastName}`;

  let modal = new bootstrap.Modal(document.getElementById('viewContactModal'));
  modal.show();
}

function saveContactEdits() {
  const id = parseInt(document.getElementById("editContactId").value);
  clearContactErrors('edit');

  const firstNameInput = document.getElementById("editFirstName").value.trim();
  const lastNameInput = document.getElementById("editLastName").value.trim();
  const emailInput = document.getElementById("editEmail").value.trim();
  const phoneInput = document.getElementById("editPhone").value.trim();

  let isValid = true;

  if (!firstNameInput) {
    const el = document.getElementById("editFirstNameError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> First name is required";
    isValid = false;
  }

  if (!lastNameInput) {
    const el = document.getElementById("editLastNameError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Last name is required";
    isValid = false;
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (emailInput !== "" && !emailRegex.test(emailInput)) {
    const el = document.getElementById("editEmailError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Invalid email format (contact@domain.ext)";
    isValid = false;
  }

  let formattedPhone = "";
  if (phoneInput !== "") {
    formattedPhone = formatPhoneNumber(phoneInput);
    if (!formattedPhone) {
      const el = document.getElementById("editPhoneError");
      if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Invalid phone number format (123-456-7890)";
      isValid = false;
    }
  }

  if (!isValid) return;

  const contact = allContacts.find(c => c.id === id);
  if (contact) {
    contact.firstName = firstNameInput;
    contact.lastName = lastNameInput;
    contact.email = emailInput;
    contact.phoneNumber = formattedPhone || phoneInput;
  }

  const modalEl = document.getElementById('viewContactModal');
  const modal = bootstrap.Modal.getInstance(modalEl);
  if (modal) modal.hide();

  fetchContacts();
}

function openDeleteModal(contactId, contactName) {
  document.getElementById("deleteContactId").value = contactId;
  document.getElementById("deleteContactName").innerText = contactName;

  let modal = new bootstrap.Modal(document.getElementById('deleteConfirmModal'));
  modal.show();
}

function confirmDeleteContact() {
  const idToDelete = parseInt(document.getElementById("deleteContactId").value);

  allContacts = allContacts.filter(c => c.id !== idToDelete);

  const modalEl = document.getElementById('deleteConfirmModal');
  const modal = bootstrap.Modal.getInstance(modalEl);
  if (modal) modal.hide();

  fetchContacts();
}

function clearProfileErrors() {
  const errorIds = [
    "profileUsernameError",
    "profileFirstNameError",
    "profileLastNameError",
    "profileEmailError",
    "profilePhoneError",
    "profileResult"
  ];

  errorIds.forEach(id => {
    const el = document.getElementById(id);
    if (el) el.innerHTML = "";
  });
}

function openProfileModal() {
  clearProfileErrors();

  const idEl = document.getElementById("profileUserId");
  const userEl = document.getElementById("profileUsername");
  const firstEl = document.getElementById("profileFirstName");
  const lastEl = document.getElementById("profileLastName");
  const emailEl = document.getElementById("profileEmail");
  const phoneEl = document.getElementById("profilePhone");

  if (idEl) idEl.value = userId;
  if (userEl) userEl.value = userName || "";
  if (firstEl) firstEl.value = firstName || "";
  if (lastEl) lastEl.value = lastName || "";
  if (emailEl) emailEl.value = userEmail || "";
  if (phoneEl) phoneEl.value = userPhone || "";

  let modal = new bootstrap.Modal(document.getElementById('profileModal'));
  modal.show();
}

function saveProfileEdits() {
  clearProfileErrors();

  const usernameInput = document.getElementById("profileUsername");
  const firstNameInput = document.getElementById("profileFirstName");
  const lastNameInput = document.getElementById("profileLastName");
  const emailInput = document.getElementById("profileEmail");
  const phoneInput = document.getElementById("profilePhone");

  const newUsername = usernameInput ? usernameInput.value.trim() : "";
  const newFirstName = firstNameInput ? firstNameInput.value.trim() : "";
  const newLastName = lastNameInput ? lastNameInput.value.trim() : "";
  const newEmail = emailInput ? emailInput.value.trim() : "";
  const newPhone = phoneInput ? phoneInput.value.trim() : "";

  let isValid = true;

  if (!newUsername) {
    const el = document.getElementById("profileUsernameError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username is required";
    isValid = false;
  } else if (newUsername.length <= 3) {
    const el = document.getElementById("profileUsernameError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username must be longer than 3 characters";
    isValid = false;
  }

  if (!newFirstName) {
    const el = document.getElementById("profileFirstNameError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> First name is required";
    isValid = false;
  }

  if (!newLastName) {
    const el = document.getElementById("profileLastNameError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Last name is required";
    isValid = false;
  }

  const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
  if (!newEmail) {
    const el = document.getElementById("profileEmailError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Email is required";
    isValid = false;
  } else if (!emailRegex.test(newEmail)) {
    const el = document.getElementById("profileEmailError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Invalid email format (contact@domain.ext)";
    isValid = false;
  }

  const phoneRegex = /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4}$/;
  if (newPhone !== "" && !phoneRegex.test(newPhone)) {
    const el = document.getElementById("profilePhoneError");
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Invalid phone number format (123-456-7890)";
    isValid = false;
  }

  if (!isValid) return;

  let jsonPayload = JSON.stringify({
    userId: userId,
    userID: userId,
    firstName: newFirstName,
    lastName: newLastName,
    userName: newUsername,
    email: newEmail,
    phoneNumber: newPhone,
    phone: newPhone
  });

  let xhr = new XMLHttpRequest();
  xhr.open("POST", updateProfileUrlBase, true);
  xhr.setRequestHeader("Content-type", "application/json; charset=UTF-8");

  try {
    xhr.onreadystatechange = function () {
      if (this.readyState === 4) {
        if (this.status === 200 || this.status === 201) {
          userName = newUsername;
          firstName = newFirstName;
          lastName = newLastName;
          userEmail = newEmail;
          userPhone = newPhone;

          const navUsername = document.getElementById("navUsername");
          if (navUsername) navUsername.innerText = userName || `${firstName}`;

          const dropdownFullName = document.getElementById("dropdownFullName");
          if (dropdownFullName) dropdownFullName.innerText = `${firstName} ${lastName}`;

          const dropdownUsername = document.getElementById("dropdownUsername");
          if (dropdownUsername) dropdownUsername.innerText = userName || "N/A";

          const dropdownEmail = document.getElementById("dropdownEmail");
          if (dropdownEmail) dropdownEmail.innerText = userEmail || "Not provided";

          const dropdownPhone = document.getElementById("dropdownPhone");
          if (dropdownPhone) dropdownPhone.innerText = userPhone || "Not provided";

          saveCookie();

          const modalEl = document.getElementById('profileModal');
          const modal = bootstrap.Modal.getInstance(modalEl);
          if (modal) modal.hide();
        } else {
          try {
            let jsonObject = JSON.parse(xhr.responseText);
            let errText = (jsonObject.error || "").toLowerCase();

            if (errText.includes("username")) {
              const el = document.getElementById('profileUsernameError');
              if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Username already in use";
            } else if (errText.includes("email") || errText.includes("already exists")) {
              const el = document.getElementById('profileEmailError');
              if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Email already in use";
            } else {
              const el = document.getElementById('profileResult');
              if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> " + (jsonObject.error || "Update failed");
            }
          } catch (e) {
            const el = document.getElementById('profileResult');
            if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> Profile update failed";
          }
        }
      }
    };
    xhr.send(jsonPayload);
  } catch (err) {
    const el = document.getElementById('profileResult');
    if (el) el.innerHTML = "<i class='bi bi-exclamation-circle-fill me-1'></i> " + err.message;
  }
}

function loadMutualContacts() {
  const mutualContainer = document.getElementById("mutualContactsList");
  if (!mutualContainer) return;

  if (mutualContacts.length === 0) {
    mutualContainer.innerHTML = `<div class="text-muted small text-center py-2">No mutual contacts found.</div>`;
    return;
  }

  let html = "";
  mutualContacts.forEach((m) => {
    html += `
      <div class="d-flex align-items-center justify-content-between p-2 rounded bg-light">
        <div>
          <div class="fw-bold text-dark small">${m.name}</div>
          <div class="text-muted extra-small" style="font-size: 0.75rem;">
            <span class="badge bg-primary-subtle text-primary border border-primary-subtle me-1">${m.mutualsCount} mutuals</span>
          </div>
        </div>
        <button class="btn btn-sm btn-outline-primary fw-semibold" onclick="openAddMutualModal(${m.id})">
          <i class="bi bi-person-add"></i> Add
        </button>
      </div>
    `;
  });

  mutualContainer.innerHTML = html;
}

function openAddMutualModal(mutualId) {
  const target = mutualContacts.find(m => m.id === mutualId);
  if (!target) return;

  document.getElementById("addMutualId").value = target.id;
  document.getElementById("addMutualName").innerText = target.name;

  let modal = new bootstrap.Modal(document.getElementById('addMutualConfirmModal'));
  modal.show();
}

function confirmAddMutualContact() {
  const mutualId = parseInt(document.getElementById("addMutualId").value);
  const target = mutualContacts.find(m => m.id === mutualId);

  if (!target) return;

  allContacts.push({
    id: Date.now(),
    firstName: target.firstName,
    lastName: target.lastName,
    email: target.email,
    phoneNumber: target.phone
  });

  mutualContacts = mutualContacts.filter(m => m.id !== mutualId);

  const modalEl = document.getElementById('addMutualConfirmModal');
  const modal = bootstrap.Modal.getInstance(modalEl);
  if (modal) modal.hide();

  loadMutualContacts();
  fetchContacts();
}

function doLogout() {
  userId = 0;
  firstName = "";
  lastName = "";
  userName = "";
  userEmail = "";
  userPhone = "";
  userRole = 1;
  document.cookie = "firstName=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
  document.cookie = "lastName=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
  document.cookie = "userName=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
  document.cookie = "email=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
  document.cookie = "phone=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
  document.cookie = "role=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
  document.cookie = "userId=; expires=Thu, 01 Jan 1970 00:00:00 GMT; path=/";
  window.location.href = "landing.html";
}