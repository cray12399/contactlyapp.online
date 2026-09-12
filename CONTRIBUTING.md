# How to work on this project

A guide for getting set up and making changes. If you're new to Git, read this
top to bottom once. Setup takes about 20 minutes.

---

## Two rules

**1. Don't edit files on the live server.** The server is where finished code
goes. All work happens on your own computer.

**2. Don't commit passwords.** Database passwords and API keys stay out of the
repo. Once something is committed it stays in the history permanently, and
deleting it later doesn't remove it. If you commit one by accident, tell Chris
right away so we can change it.

---

## What we're building on

The site runs on PHP with a MySQL database. To work on it you need both of those
running on your own machine. The setup below installs them.

---

## Setup (do this once)

### Step 1: Get Linux running

**On Windows, use WSL.** It runs Ubuntu Linux inside Windows.

Open **PowerShell as Administrator** (right-click, then Run as administrator):

```powershell
wsl --install -d Ubuntu-24.04
```

Restart your computer. When Ubuntu opens it asks you to make a username and
password. Write the password down, because you'll need it for `sudo` commands.
It's separate from your Windows password.

From now on, "open your terminal" means open the **Ubuntu** app, not PowerShell.

**On Mac** you already have a Unix terminal. Skip to Step 2 and use
[Homebrew](https://brew.sh) instead of `apt`:
`brew install php mysql git`

### Step 2: Install PHP, MySQL, and Git

In your Ubuntu terminal:

```bash
sudo apt update
sudo apt install php php-mysql php-curl php-mbstring php-xml mysql-server git -y
```

It asks for the password you just made. Nothing appears on screen while you type
it. That's normal. Keep typing and press Enter.

Start the database:

```bash
sudo service mysql start
```

Run that line again each time you restart your computer.

### Step 3: Connect to GitHub

GitHub needs to know your computer is really you. Make a key:

```bash
ssh-keygen -t ed25519 -C "your-name"
```

Press Enter three times to accept the defaults. Then show the key:

```bash
cat ~/.ssh/id_ed25519.pub
```

Copy the whole line it prints. On GitHub, click your profile picture, then
**Settings**, then **SSH and GPG keys**, then **New SSH key**. Paste it in, give
it any name, and save.

Test it:

```bash
ssh -T git@github.com
```

Type `yes` if it asks. You should see a message with your username in it.

### Step 4: Download the code

```bash
mkdir ~/projects
cd ~/projects
git clone git@github.com:cray12399/contactlyapp.online.git
cd contactlyapp.online
```

> **Windows users:** keep the project in `~/projects` like this. If you put it in
> your Windows folders (anything starting with `/mnt/c/`), everything gets very
> slow.

### Step 5: Set up the database

```bash
sudo mysql
```

That opens a `mysql>` prompt. Paste these lines in:

```sql
CREATE DATABASE contactsdb;
CREATE USER 'contactly'@'localhost' IDENTIFIED BY 'localpassword';
GRANT ALL PRIVILEGES ON contactsdb.* TO 'contactly'@'localhost';
EXIT;
```

Then load the tables:

```bash
mysql -u contactly -p contactsdb < database/schema.sql
```

The password is `localpassword` from above. This database only exists on your
computer, so a simple password is fine.

That creates the `Users` and `Contacts` tables, the same ones the live site uses,
with no data in them. Add your own test records as you go.

### Step 6: Run it

```bash
php -S localhost:8000
```

Open **http://localhost:8000** in your browser. You should see the site.

Leave that terminal window running while you work. `Ctrl+C` stops it.

### Step 7 (optional): Edit in VS Code

Install the **WSL** extension in VS Code. Then from your Ubuntu terminal, inside
the project folder:

```bash
code .
```

VS Code opens the project properly connected to Linux.

---

## Making changes

This is the loop you repeat every time you work on something.

### 1. Get the latest code

```bash
git checkout main
git pull origin main
```

`main` is the official version of the project. Always start from an up-to-date
copy, otherwise you'll end up fighting merge conflicts later.

### 2. Make a branch

```bash
git checkout -b login-page
```

A branch is your own copy to experiment in. Nothing you do on it affects anyone
else until you ask for it to be merged. Name it after what you're working on:
`login-page`, `fix-signup-bug`, `contact-form`.

### 3. Write your code

Edit files, refresh the browser, repeat.

### 4. Save your work to Git

```bash
git status
```

This shows what you changed. **Read it before moving on.** If you see `.env` or
any file with passwords in it, stop and tell Chris.

```bash
git add .
git commit -m "Add validation to the login form"
```

`add` picks which changes to save and `commit` saves them. Write a message that
says what you did. A message like "fix" or "changes" won't mean anything to
anyone in two weeks.

You can commit as many times as you want. Committing often is good.

### 5. Send it to GitHub

```bash
git push -u origin login-page
```

After the first push on a branch, plain `git push` works.

### 6. Open a pull request

Go to the repo on GitHub. There will be a banner offering to open a pull request
for your branch. Click it.

A pull request is how you ask someone to look at your work before it goes into
the project. Write a sentence or two about what you changed and how to test it.
Add screenshots for anything visual.

Someone else reviews it and merges it. Then you go back to step 1 for your next
piece of work.

### Quick check before you push

- Does the page still load without errors?
- Did you actually click through the thing you changed?
- Does `git status` show any config files or passwords?
- Did you leave any debug code (`var_dump`, `console.log`) behind?

---

## Reviewing someone else's pull request

Every pull request needs one other person to approve it. To look at someone's
work:

```bash
git fetch origin
git checkout their-branch-name
```

Run it, click around, and see if it works. Leave comments on GitHub. Asking "why
this way?" is a normal review comment and nobody will take it as criticism.

When you're done, switch back:

```bash
git checkout main
```

---

## Things that go wrong

**`Permission denied (publickey)`**
Your SSH key isn't set up. Redo Step 3.

**`Could not connect to database`**
MySQL isn't running. `sudo service mysql start`

**Blank white page**
A PHP error is happening silently. Run this once to make errors visible:
```bash
echo "display_errors = On" | sudo tee -a /etc/php/*/cli/php.ini
```
Then restart `php -S localhost:8000`.

**`Your local changes would be overwritten by merge`**
You have uncommitted work. Either commit it, or run `git stash` to set it aside
and `git stash pop` to get it back.

**Merge conflict**
Git found two people changing the same lines. Run `git merge --abort` to undo,
then ask for help. These are confusing the first few times and simple once
somebody walks you through one.

**Everything is slow (Windows)**
Your project is in `/mnt/c/`. Move it to `~/projects`.

**You broke something and want to start over**
```bash
git checkout .
```
That undoes all uncommitted changes. Anything you already committed is safe.

---

## Never commit these

```
.env or any config file with real passwords
*.sql database dumps (database/schema.sql is the one exception)
vendor/  or  node_modules/
uploads/
```

---

