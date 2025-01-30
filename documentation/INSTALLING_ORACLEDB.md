# Installing OrientDB

## **Step 1: Download OrientDB**
1. Go to the official OrientDB website:  
   👉 [https://orientdb.org/download/](https://orientdb.org/download/)
2. Download the latest **Community Edition** (free) or **Enterprise Edition** (requires a license).
3. Choose the correct version for your operating system:
   - **Windows**: `.zip`
   - **Mac/Linux**: `.tar.gz`

---

## **Step 2: Extract the Files**
- **Windows**:  
  Extract the `.zip` file using Windows Explorer or tools like WinRAR/7-Zip.
- **Mac/Linux**:  
  Run the following command in the terminal:
  ```sh
  tar -xvzf orientdb-community-x.x.x.tar.gz
  ```

---

## **Step 3: Run OrientDB Server**
1. **Navigate to the OrientDB directory**:
   ```sh
   cd orientdb-community-x.x.x/bin
   ```
2. **Start the server**:
   - **Windows**:
     ```sh
     server.bat
     ```
   - **Mac/Linux**:
     ```sh
     ./server.sh
     ```
3. If prompted, create an **admin password** for OrientDB.

---

## **Step 4: Access the OrientDB Studio**
Once the server is running, open your browser and go to:  
👉 **http://localhost:2480**

This is the OrientDB Web Studio, where you can manage databases.

---

## **Step 5: Create a New Database**
1. Log in using the `admin` user and the password you set earlier.
2. Click on **Create Database**.
3. Choose a name, select the database type (`Graph`, `Document`, or `Object`), and click **Create**.

---

## **Step 6: Stop the Server (If Needed)**
- **Windows**: Close the command prompt or use:
  ```sh
  CTRL + C
  ```
- **Mac/Linux**:
  ```sh
  ./shutdown.sh
  ```

---

## **Additional Resources**
- [Official Documentation](https://orientdb.com/docs/)
- [OrientDB GitHub](https://github.com/orientechnologies/orientdb)
