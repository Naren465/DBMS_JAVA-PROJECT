# CRUISEBUS – Premium Bus Reservation System

> **Tagline:** *"Travel Smart. Book Easy."*  
> **Architecture:** Model-View-Controller (MVC)  
> **Backend:** Java Servlets, JDBC, MySQL  
> **Frontend:** JSP, HTML5, CSS3, JavaScript (Glassmorphism Luxury Theme)  
> **Server:** Apache Tomcat  
> **Build Management:** Maven (`pom.xml`)  

---

## 1. Executive Summary & Design Inspiration

**CRUISEBUS** is a full-stack, enterprise-grade bus ticket reservation platform developed strictly according to the five uploaded reference UI designs. The application delivers a high-end, dark cinematic aesthetic with navy-blue glassmorphism, subtle neon-blue borders, white/silver typography, and professional interstate coach imagery.

### Visual Reproduction Breakdown

| Page | Reference Design | Key Features Implemented |
|---|---|---|
| **Page 1: Login & Signup** | Reference Image 1 | Split hero layout; *"THE ROAD THAT BELONGS TO YOU"*; luxury coach visual; glassmorphism card with **Sign In** and **Create Account** tabs; secure password hashing; demo credentials hint. |
| **Page 2: Home Page** | Reference Image 2 *(Highest Priority)* | Transparent top navigation bar with glowing active pill; night city highway backdrop; main heading *"BUS TICKET BOOKING PLATFORM"*; glass search bar with departure, destination, date picker, and glowing *"Search Bus"* button; *"Why Book With Us?"* with 3 feature cards; bottom 5 service navigation cards (**Agent App (POS)**, **Admin Panel**, **Mobile App**, **Driver App**, **Bus Tracker**). |
| **Page 3: About Us** | Reference Image 3 | Heading *"About CruiseBus"* and subtitle *"Redefining Journey, Connect with Comfort."*; glowing transit globe illustration with 3 statistics (**10,000+ Journeys**, **500+ Safe Buses**, **24/7 Support**); glass card with Our Mission, Why Choose Us, and *"Explore Our Services"* button. |
| **Page 4: Download Ticket** | Reference Image 4 | Heading *"Download Ticket"*; luxury reservation details card displaying route (**Chennai - Bengaluru**), date (**14 Dec 2021, Monday**), Bus Name (**Bengaluru Express**), Seat Number (**06, 07**), Ticket ID (**LA325478**), Bus Number (**KA 01 FB 1234**), Arrival/Drop times, and Total Fare (**₹ 4,020.00**); dynamic QR code; **Cancel** and **Download** (print/PDF) buttons. |
| **Page 5: Search Bus Results** | Reference Image 5 | Sub-navigation bar with user profile badge (**PA Primary Admin**), **BROWSE** (active), **MY BOOKINGS**, **ID VERIFICATION**, **CUSTOMER CARE**, **ADMIN**, **SIGN OUT**; model search bar; filter sidebar (Price Range, Bus Operator, Bus Type); 2-column luxury bus grid (**KSRTC Super Deluxe**, **Volvo 9600**, **RedBus Smart Bus**, **SRS Travels Volvo**) with bus specs and **Book Now** buttons; floating chat bubble in bottom-right. |

---

## 2. Technology Stack

- **Backend:** Java 17+ (Servlets 3.1 / 4.0)
- **Frontend:** JSP (JavaServer Pages), JSTL 1.2, HTML5, CSS3, Vanilla JavaScript
- **Database:** MySQL 10.4 / 8.0 (`cruisebus_db`)
- **Database Connectivity:** JDBC with PreparedStatements and atomic transactions
- **Server:** Apache Tomcat 8.5 / 9.0 / 10.0
- **Build System:** Apache Maven (`pom.xml`) & automated batch build tools

---

## 3. System Architecture (MVC)

```
c:\Users\K VIGNESH\OneDrive\Desktop\busticket\
│
├── database/
│   └── cruisebus_schema.sql         # Full normalized database schema & sample seed data
│
├── src/main/java/com/cruisebus/
│   ├── controller/
│   │   ├── HomeServlet.java          # Serves homepage and route lookups (/home, /)
│   │   ├── AuthServlet.java          # Handles Login, Signup, Logout (/auth, /login, /signup, /logout)
│   │   ├── SearchBusServlet.java     # Filters buses by route, operator, type, price, model (/search)
│   │   ├── SeatSelectionServlet.java # Renders interactive bus cabin seat layout (/seats)
│   │   ├── BookingServlet.java       # Atomic DB transaction for seat reservation (/book)
│   │   ├── TicketServlet.java        # Reservation details, PNR tracking, cancellation (/ticket)
│   │   ├── AboutServlet.java         # Serves About page (/about)
│   │   ├── ContactServlet.java       # Concierge message submissions (/contact)
│   │   └── AdminServlet.java         # Fleet, routes, schedules, bookings, customers manager (/admin)
│   │
│   ├── dao/
│   │   ├── CustomerDAO.java          # Customer registration, login, queries
│   │   ├── BusDAO.java               # Bus fleet CRUD and operator queries
│   │   ├── RouteDAO.java             # Route origins and destination hubs
│   │   ├── ScheduleDAO.java          # Multi-criteria schedule search and filtering
│   │   ├── SeatDAO.java              # Cabin seat initialization and schedule availability
│   │   ├── BookingDAO.java           # Transactional seat booking with concurrency lock
│   │   ├── PaymentDAO.java           # Payment verification and tracking
│   │   ├── TicketDAO.java            # Ticket generation and QR code data
│   │   └── ContactMessageDAO.java    # Customer support inquiry storage
│   │
│   ├── model/
│   │   ├── Customer.java, Bus.java, Route.java, Schedule.java, Seat.java,
│   │   ├── Booking.java, BookingSeat.java, Payment.java, Ticket.java, ContactMessage.java
│   │
│   ├── util/
│   │   ├── DBUtil.java               # Thread-safe JDBC Connection factory
│   │   ├── PasswordUtil.java         # SHA-256 salted password hashing & verification
│   │   └── QRCodeUtil.java           # Ticket QR data generation
│   │
│   └── filter/
│       └── AuthFilter.java           # Session guard for authenticated customer pages
│
├── src/main/webapp/
│   ├── assets/
│   │   ├── css/                      # style.css, home.css, auth.css, about.css, ticket.css, search.css, seat-selection.css, admin.css
│   │   ├── js/                       # app.js, seat-selection.js, ticket.js
│   │   └── images/                   # bus_ksrtc.jpg, bus_volvo.jpg, bus_redbus.jpg, bus_srs.jpg, luxury_bus_hero.png, ref_*.jpg
│   └── WEB-INF/
│       ├── lib/                      # mysql-connector-j-8.3.0.jar, jstl-1.2.jar, gson-2.10.1.jar
│       ├── classes/                  # Compiled bytecode
│       ├── views/                    # JSP views (home, login, about, ticket, search, seat-selection, contact, admin/*)
│       └── web.xml                   # Deployment descriptor with servlet mappings
│
├── pom.xml                           # Maven project configuration
├── compile_project.bat               # One-click Java compilation and Tomcat deployment
└── start_cruisebus.bat               # Starts MySQL + Tomcat and launches the application
```

---

## 4. Database Design (`cruisebus_db`)

The database is properly normalized with primary keys, foreign keys, cascade rules, and check constraints:

1. **`CUSTOMER`**: `customer_id`, `name`, `email` *(UNIQUE)*, `phone`, `password` *(Hashed)*, `role` (`CUSTOMER` / `ADMIN`), `created_at`.
2. **`BUS`**: `bus_id`, `bus_name`, `operator`, `bus_number` *(UNIQUE)*, `bus_type` (`AC Sleeper`, `AC Seater`, `Non AC Seater`), `total_seats`, `fuel_type`, `transmission`, `image_url`.
3. **`ROUTE`**: `route_id`, `source`, `destination`, `distance`.
4. **`SCHEDULE`**: `schedule_id`, `bus_id`, `route_id`, `departure_date`, `departure_time`, `arrival_time`, `fare`.
5. **`SEAT`**: `seat_id`, `bus_id`, `seat_number`, `seat_status` (`AVAILABLE`, `BOOKED`), `seat_type`, `deck` (`LOWER`, `UPPER`).
6. **`BOOKING`**: `booking_id`, `ticket_pnr` *(UNIQUE)*, `customer_id`, `schedule_id`, `booking_date`, `total_amount`, `booking_status` (`CONFIRMED`, `CANCELLED`).
7. **`BOOKING_SEAT`**: `booking_seat_id`, `booking_id`, `seat_id`, `passenger_name`, `passenger_age`, `passenger_gender`.
8. **`PAYMENT`**: `payment_id`, `booking_id`, `payment_amount`, `payment_status`, `payment_date`, `payment_method`, `transaction_ref`.
9. **`TICKET`**: `ticket_id`, `booking_id`, `seat_id`, `qr_code_data`, `issued_date`.
10. **`CONTACT_MESSAGE`**: `message_id`, `name`, `email`, `phone`, `subject`, `message`, `submitted_at`.

### Concurrency Protection
To prevent two passengers from booking the same seat simultaneously:
`BookingDAO.createBookingTransactional(...)` runs in an isolated database transaction (`conn.setAutoCommit(false)`), executing `SELECT ... FOR UPDATE` on candidate seats. If another transaction has locked or committed that seat, an `IllegalStateException` is raised, rolling back the transaction and alerting the user.

---

## 5. Demo Credentials

| Role | Email | Password | Access Level |
|---|---|---|---|
| **Demo Customer** | `demo@cruisebus.in` | `Demo@123` | Book seats, manage reservations, download tickets |
| **Primary Administrator** | `admin@cruisebus.in` | `Admin@123` | Full Admin Console (Fleet, Routes, Schedules, Bookings, Customers, Messages) |

*(New users can also register instantly via the Create Account tab on Page 1).*

---

## 6. How to Run the Project

### Quick Launch (Automated)
Double-click `start_cruisebus.bat` in the project root. It will:
1. Ensure the MySQL server is running.
2. Launch Apache Tomcat on port `8080`.
3. Open your browser directly to `http://localhost:8080/cruisebus/home`.

### Running in VS Code
1. Open the `busticket` folder in **Visual Studio Code**.
2. If using the **Tomcat for Java** extension in VS Code:
   - Add Tomcat Server (`C:\xampp\tomcat`).
   - Right-click the project folder or `pom.xml` and choose **Run on Server**.
3. Or compile anytime by opening the terminal in VS Code and running:
   ```powershell
   .\compile_project.bat
   ```
4. Access the application URLs:
   - **Home Page:** [http://localhost:8080/cruisebus/home](http://localhost:8080/cruisebus/home)
   - **Login & Signup:** [http://localhost:8080/cruisebus/auth](http://localhost:8080/cruisebus/auth)
   - **About Us:** [http://localhost:8080/cruisebus/about](http://localhost:8080/cruisebus/about)
   - **Search Bus Results:** [http://localhost:8080/cruisebus/search](http://localhost:8080/cruisebus/search)
   - **Download Ticket:** [http://localhost:8080/cruisebus/ticket?pnr=LA325478](http://localhost:8080/cruisebus/ticket?pnr=LA325478)
   - **Admin Console:** [http://localhost:8080/cruisebus/admin?demo_admin=true](http://localhost:8080/cruisebus/admin?demo_admin=true)
   - **Contact Us:** [http://localhost:8080/cruisebus/contact](http://localhost:8080/cruisebus/contact)
