<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.studentbazaar.model.Product" %>
<%@ page import="com.studentbazaar.dao.CartDAO" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Buy Products - StudentBazaar</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">

    <!-- Font Awesome + Bootstrap -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

    <!-- AOS (Animate On Scroll) CSS -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.css" rel="stylesheet" />

    <!-- Your global CSS -->
    <link rel="stylesheet" href="css/studentbazaar.css" />
</head>
<body>

    <%@ include file="header.jsp" %>

    <div class="page-bg buy-page">
    
    
    
<div class="layout-wrapper buy-wrapper">

    <!--  HERO CARD -->
    <div class="buy-hero-card" data-aos="fade-up">

        <!-- LEFT TEXT -->
        <div class="buy-hero-text">
            <h1 class="buy-hero-title">Explore Product Categories</h1>

            <p class="buy-hero-subtitle">
                Browse 40+ student-friendly categories. Use smart search to jump directly to what you need.
            </p>

            <p class="buy-hero-mini">
                Popular: Mobiles · Books · Shoes · Bags
            </p>
        </div>

        <!-- RIGHT SEARCH -->
        <div class="buy-hero-actions">
            <div class="search-wrapper">
                <input id="smartSearch"
                       type="text"
                       class="form-control search-input pe-5"
                       placeholder="Search categories (Mobiles, Books, Shoes...)"
                       oninput="suggestCategory()">


                <ul id="suggestions" class="list-group"></ul>
            </div>
        </div>

    </div>




            <!--  Section title -->
            <h2 class="section-title" data-aos="fade-up">
                Browse by Category
            </h2>

            <!-- ✅ 4 sample cards (you will paste the rest later) -->
            <div class="category-grid">

                <!-- MOBILES CARD -->
                <div class="category-card" data-category="mobiles" data-aos="zoom-in">
                    <div class="card-carousel-container">
                        <div id="carouselMobiles" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
                            <div class="carousel-indicators">
                                <button type="button" data-bs-target="#carouselMobiles" data-bs-slide-to="0" class="active"></button>
                                <button type="button" data-bs-target="#carouselMobiles" data-bs-slide-to="1"></button>
                                <button type="button" data-bs-target="#carouselMobiles" data-bs-slide-to="2"></button>
                                <button type="button" data-bs-target="#carouselMobiles" data-bs-slide-to="3"></button>
                            </div>
                            <div class="carousel-inner">
                                <div class="carousel-item active"><img src="img/products/mobiles/mobile1.jpg" class="d-block w-100" alt="Mobile 1"></div>
                                <div class="carousel-item"><img src="img/products/mobiles/mobile2.jpg" class="d-block w-100" alt="Mobile 2"></div>
                                <div class="carousel-item"><img src="img/products/mobiles/mobile3.jpg" class="d-block w-100" alt="Mobile 3"></div>
                                <div class="carousel-item"><img src="img/products/mobiles/mobile4.jpg" class="d-block w-100" alt="Mobile 4"></div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carouselMobiles" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon"></span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carouselMobiles" data-bs-slide="next">
                                <span class="carousel-control-next-icon"></span>
                            </button>
                        </div>
                    </div>
                    <h3>Mobiles</h3>
                    <a href="CategoryServlet?category=Mobiles" class="btn btn-info">View More</a>
                </div>

                <!-- BOOKS CARD -->
                <div class="category-card" data-category="books" data-aos="zoom-in">
                    <div class="card-carousel-container">
                        <div id="carouselBooks" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
                            <div class="carousel-indicators">
                                <button type="button" data-bs-target="#carouselBooks" data-bs-slide-to="0" class="active"></button>
                                <button type="button" data-bs-target="#carouselBooks" data-bs-slide-to="1"></button>
                                <button type="button" data-bs-target="#carouselBooks" data-bs-slide-to="2"></button>
                                <button type="button" data-bs-target="#carouselBooks" data-bs-slide-to="3"></button>
                            </div>
                            <div class="carousel-inner">
                                <div class="carousel-item active"><img src="img/products/books/book1.jpg" class="d-block w-100" alt="Book 1"></div>
                                <div class="carousel-item"><img src="img/products/books/book2.jpg" class="d-block w-100" alt="Book 2"></div>
                                <div class="carousel-item"><img src="img/products/books/book3.jpg" class="d-block w-100" alt="Book 3"></div>
                                <div class="carousel-item"><img src="img/products/books/book4.jpg" class="d-block w-100" alt="Book 4"></div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carouselBooks" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon"></span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carouselBooks" data-bs-slide="next">
                                <span class="carousel-control-next-icon"></span>
                            </button>
                        </div>
                    </div>
                    <h3>Books</h3>
                    <a href="CategoryServlet?category=Books" class="btn btn-info">View More</a>
                </div>

                <!-- SHOES CARD -->
                <div class="category-card" data-category="shoes" data-aos="zoom-in">
                    <div class="card-carousel-container">
                        <div id="carouselShoes" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
                            <div class="carousel-indicators">
                                <button type="button" data-bs-target="#carouselShoes" data-bs-slide-to="0" class="active"></button>
                                <button type="button" data-bs-target="#carouselShoes" data-bs-slide-to="1"></button>
                                <button type="button" data-bs-target="#carouselShoes" data-bs-slide-to="2"></button>
                                <button type="button" data-bs-target="#carouselShoes" data-bs-slide-to="3"></button>
                            </div>
                            <div class="carousel-inner">
                                <div class="carousel-item active"><img src="img/products/shoes/shoe1.jpg" class="d-block w-100" alt="Shoe 1"></div>
                                <div class="carousel-item"><img src="img/products/shoes/shoe2.jpg" class="d-block w-100" alt="Shoe 2"></div>
                                <div class="carousel-item"><img src="img/products/shoes/shoe3.jpg" class="d-block w-100" alt="Shoe 3"></div>
                                <div class="carousel-item"><img src="img/products/shoes/shoe4.jpg" class="d-block w-100" alt="Shoe 4"></div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carouselShoes" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon"></span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carouselShoes" data-bs-slide="next">
                                <span class="carousel-control-next-icon"></span>
                            </button>
                        </div>
                    </div>
                    <h3>Shoes</h3>
                    <a href="CategoryServlet?category=Shoes" class="btn btn-info">View More</a>
                </div>

                <!-- BAGS CARD -->
                <div class="category-card" data-category="bags" data-aos="zoom-in">
                    <div class="card-carousel-container">
                        <div id="carouselBags" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
                            <div class="carousel-indicators">
                                <button type="button" data-bs-target="#carouselBags" data-bs-slide-to="0" class="active"></button>
                                <button type="button" data-bs-target="#carouselBags" data-bs-slide-to="1"></button>
                                <button type="button" data-bs-target="#carouselBags" data-bs-slide-to="2"></button>
                                <button type="button" data-bs-target="#carouselBags" data-bs-slide-to="3"></button>
                            </div>
                            <div class="carousel-inner">
                                <div class="carousel-item active"><img src="img/products/bags/bag1.jpg" class="d-block w-100" alt="Bag 1"></div>
                                <div class="carousel-item"><img src="img/products/bags/bag2.jpg" class="d-block w-100" alt="Bag 2"></div>
                                <div class="carousel-item"><img src="img/products/bags/bag3.jpg" class="d-block w-100" alt="Bag 3"></div>
                                <div class="carousel-item"><img src="img/products/bags/bag4.jpg" class="d-block w-100" alt="Bag 4"></div>
                            </div>
                            <button class="carousel-control-prev" type="button" data-bs-target="#carouselBags" data-bs-slide="prev">
                                <span class="carousel-control-prev-icon"></span>
                            </button>
                            <button class="carousel-control-next" type="button" data-bs-target="#carouselBags" data-bs-slide="next">
                                <span class="carousel-control-next-icon"></span>
                            </button>
                        </div>
                    </div>
                    <h3>Bags</h3>
                    <a href="CategoryServlet?category=Bags" class="btn btn-info">View More</a>
                </div>
<!-- WATCHES -->
<div class="category-card" data-category="watches">
  <div class="card-carousel-container">
    <div id="carouselWatches" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselWatches" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselWatches" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselWatches" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselWatches" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/watches/watch1.jpg" class="d-block w-100" alt="Watch 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/watches/watch2.jpg" class="d-block w-100" alt="Watch 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/watches/watch3.jpg" class="d-block w-100" alt="Watch 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/watches/watch4.jpg" class="d-block w-100" alt="Watch 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselWatches" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselWatches" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Watches</h3>
  <a href="CategoryServlet?category=Watches" class="btn btn-info">View More</a>
</div>

<!-- STATIONERY -->
<div class="category-card" data-category="stationery">
  <div class="card-carousel-container">
    <div id="carouselStationery" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselStationery" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselStationery" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselStationery" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselStationery" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/stationery/stationery1.jpg" class="d-block w-100" alt="Stationery 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/stationery/stationery2.jpg" class="d-block w-100" alt="Stationery 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/stationery/stationery3.jpg" class="d-block w-100" alt="Stationery 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/stationery/stationery4.jpg" class="d-block w-100" alt="Stationery 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselStationery" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselStationery" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Stationery</h3>
  <a href="CategoryServlet?category=Stationery" class="btn btn-info">View More</a>
</div>

<!-- SPEAKERS -->
<div class="category-card" data-category="speakers">
  <div class="card-carousel-container">
    <div id="carouselSpeakers" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselSpeakers" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselSpeakers" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselSpeakers" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselSpeakers" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/speakers/speaker1.jpg" class="d-block w-100" alt="Speaker 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/speakers/speaker2.jpg" class="d-block w-100" alt="Speaker 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/speakers/speaker3.jpg" class="d-block w-100" alt="Speaker 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/speakers/speaker4.jpg" class="d-block w-100" alt="Speaker 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselSpeakers" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselSpeakers" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Speakers</h3>
  <a href="CategoryServlet?category=Speakers" class="btn btn-info">View More</a>
</div>

<!-- CLOTHES -->
<div class="category-card" data-category="clothes">
  <div class="card-carousel-container">
    <div id="carouselClothes" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselClothes" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselClothes" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselClothes" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselClothes" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/clothes/clothes1.jpg" class="d-block w-100" alt="Clothes 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/clothes/clothes2.jpg" class="d-block w-100" alt="Clothes 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/clothes/clothes3.jpg" class="d-block w-100" alt="Clothes 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/clothes/clothes4.jpg" class="d-block w-100" alt="Clothes 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselClothes" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselClothes" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Clothes</h3>
  <a href="CategoryServlet?category=Clothes" class="btn btn-info">View More</a>
</div>

<!-- GAMING -->
<div class="category-card" data-category="gaming">
  <div class="card-carousel-container">
    <div id="carouselGaming" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselGaming" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselGaming" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselGaming" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselGaming" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/gaming/gaming1.jpg" class="d-block w-100" alt="Gaming 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/gaming/gaming2.jpg" class="d-block w-100" alt="Gaming 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/gaming/gaming3.jpg" class="d-block w-100" alt="Gaming 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/gaming/gaming4.jpg" class="d-block w-100" alt="Gaming 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselGaming" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselGaming" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Gaming</h3>
  <a href="CategoryServlet?category=Gaming" class="btn btn-info">View More</a>
</div>

<!-- HEADPHONES -->
<div class="category-card" data-category="headphones">
  <div class="card-carousel-container">
    <div id="carouselHeadphones" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselHeadphones" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselHeadphones" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselHeadphones" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselHeadphones" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/headphones/headphone1.jpg" class="d-block w-100" alt="Headphone 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/headphones/headphone2.jpg" class="d-block w-100" alt="Headphone 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/headphones/headphone3.jpg" class="d-block w-100" alt="Headphone 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/headphones/headphone4.jpg" class="d-block w-100" alt="Headphone 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselHeadphones" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselHeadphones" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Headphones</h3>
  <a href="CategoryServlet?category=Headphones" class="btn btn-info">View More</a>
</div>

<!-- LAPTOPS -->
<div class="category-card" data-category="laptops">
  <div class="card-carousel-container">
    <div id="carouselLaptops" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselLaptops" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselLaptops" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselLaptops" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselLaptops" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/laptops/laptop1.jpg" class="d-block w-100" alt="Laptop 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/laptops/laptop2.jpg" class="d-block w-100" alt="Laptop 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/laptops/laptop3.jpg" class="d-block w-100" alt="Laptop 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/laptops/laptop4.jpg" class="d-block w-100" alt="Laptop 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselLaptops" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselLaptops" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Laptops</h3>
  <a href="CategoryServlet?category=Laptops" class="btn btn-info">View More</a>
</div>

<!-- FURNITURE -->
<div class="category-card" data-category="furniture">
  <div class="card-carousel-container">
    <div id="carouselFurniture" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselFurniture" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselFurniture" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselFurniture" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselFurniture" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/furniture/furniture1.jpg" class="d-block w-100" alt="Furniture 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/furniture/furniture2.jpg" class="d-block w-100" alt="Furniture 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/furniture/furniture3.jpg" class="d-block w-100" alt="Furniture 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/furniture/furniture4.jpg" class="d-block w-100" alt="Furniture 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselFurniture" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselFurniture" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Furniture</h3>
  <a href="CategoryServlet?category=Furniture" class="btn btn-info">View More</a>
</div>
<!-- BICYCLES -->
<div class="category-card" data-category="bicycles">
  <div class="card-carousel-container">
    <div id="carouselBicycles" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselBicycles" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselBicycles" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselBicycles" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselBicycles" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/bicycles/bicycle1.jpg" class="d-block w-100" alt="Bicycle 1"></div>
        <div class="carousel-item"><img src="img/products/bicycles/bicycle2.jpg" class="d-block w-100" alt="Bicycle 2"></div>
        <div class="carousel-item"><img src="img/products/bicycles/bicycle3.jpg" class="d-block w-100" alt="Bicycle 3"></div>
        <div class="carousel-item"><img src="img/products/bicycles/bicycle4.jpg" class="d-block w-100" alt="Bicycle 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselBicycles" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselBicycles" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Bicycles</h3>
  <a href="CategoryServlet?category=Bicycles" class="btn btn-info">View More</a>
</div>

<!-- BIKES -->
<div class="category-card" data-category="bikes">
  <div class="card-carousel-container">
    <div id="carouselBikes" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselBikes" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselBikes" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselBikes" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselBikes" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/bikes/bike1.jpg" class="d-block w-100" alt="Bike 1"></div>
        <div class="carousel-item"><img src="img/products/bikes/bike2.jpg" class="d-block w-100" alt="Bike 2"></div>
        <div class="carousel-item"><img src="img/products/bikes/bike3.jpg" class="d-block w-100" alt="Bike 3"></div>
        <div class="carousel-item"><img src="img/products/bikes/bike4.jpg" class="d-block w-100" alt="Bike 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselBikes" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselBikes" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Bikes</h3>
  <a href="CategoryServlet?category=Bikes" class="btn btn-info">View More</a>
</div>

<!-- POWERBANKS -->
<div class="category-card" data-category="powerbanks">
  <div class="card-carousel-container">
    <div id="carouselPowerbanks" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselPowerbanks" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselPowerbanks" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselPowerbanks" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselPowerbanks" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/powerbanks/powerbank1.jpg" class="d-block w-100" alt="Powerbank 1"></div>
        <div class="carousel-item"><img src="img/products/powerbanks/powerbank2.jpg" class="d-block w-100" alt="Powerbank 2"></div>
        <div class="carousel-item"><img src="img/products/powerbanks/powerbank3.jpg" class="d-block w-100" alt="Powerbank 3"></div>
        <div class="carousel-item"><img src="img/products/powerbanks/powerbank4.jpg" class="d-block w-100" alt="Powerbank 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselPowerbanks" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselPowerbanks" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Powerbanks</h3>
  <a href="CategoryServlet?category=Powerbanks" class="btn btn-info">View More</a>
</div>

<!-- SPORTS -->
<div class="category-card" data-category="sports">
  <div class="card-carousel-container">
    <div id="carouselSports" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselSports" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselSports" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselSports" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselSports" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/sports/sport1.jpg" class="d-block w-100" alt="Sport 1"></div>
        <div class="carousel-item"><img src="img/products/sports/sport2.jpg" class="d-block w-100" alt="Sport 2"></div>
        <div class="carousel-item"><img src="img/products/sports/sport3.jpg" class="d-block w-100" alt="Sport 3"></div>
        <div class="carousel-item"><img src="img/products/sports/sport4.jpg" class="d-block w-100" alt="Sport 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselSports" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselSports" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Sports</h3>
  <a href="CategoryServlet?category=Sports" class="btn btn-info">View More</a>
</div>

<!-- EAR BUDS -->
<div class="category-card" data-category="earbuds">
  <div class="card-carousel-container">
    <div id="carouselEarbuds" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselEarbuds" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselEarbuds" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselEarbuds" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselEarbuds" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/earbuds/earbud1.jpg" class="d-block w-100" alt="Earbud 1"></div>
        <div class="carousel-item"><img src="img/products/earbuds/earbud2.jpg" class="d-block w-100" alt="Earbud 2"></div>
        <div class="carousel-item"><img src="img/products/earbuds/earbud3.jpg" class="d-block w-100" alt="Earbud 3"></div>
        <div class="carousel-item"><img src="img/products/earbuds/earbud4.jpg" class="d-block w-100" alt="Earbud 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselEarbuds" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselEarbuds" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Ear Buds</h3>
  <a href="CategoryServlet?category=Earbuds" class="btn btn-info">View More</a>
</div>

<!-- WALL CLOCKS -->
<div class="category-card" data-category="wallclocks">
  <div class="card-carousel-container">
    <div id="carouselWallclocks" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselWallclocks" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselWallclocks" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselWallclocks" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselWallclocks" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/wallclocks/wallclock1.jpg" class="d-block w-100" alt="Wall Clock 1"></div>
        <div class="carousel-item"><img src="img/products/wallclocks/wallclock2.jpg" class="d-block w-100" alt="Wall Clock 2"></div>
        <div class="carousel-item"><img src="img/products/wallclocks/wallclock3.jpg" class="d-block w-100" alt="Wall Clock 3"></div>
        <div class="carousel-item"><img src="img/products/wallclocks/wallclock4.jpg" class="d-block w-100" alt="Wall Clock 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselWallclocks" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselWallclocks" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Wall Clocks</h3>
  <a href="CategoryServlet?category=wallclocks" class="btn btn-info">View More</a>
</div>

<!-- LAMPS -->
<div class="category-card" data-category="lamps">
  <div class="card-carousel-container">
    <div id="carouselLamps" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselLamps" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselLamps" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselLamps" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselLamps" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/lamps/lamp1.jpg" class="d-block w-100" alt="Lamp 1"></div>
        <div class="carousel-item"><img src="img/products/lamps/lamp2.jpg" class="d-block w-100" alt="Lamp 2"></div>
        <div class="carousel-item"><img src="img/products/lamps/lamp3.jpg" class="d-block w-100" alt="Lamp 3"></div>
        <div class="carousel-item"><img src="img/products/lamps/lamp4.jpg" class="d-block w-100" alt="Lamp 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselLamps" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselLamps" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Lamps</h3>
  <a href="CategoryServlet?category=Lamps" class="btn btn-info">View More</a>
</div>

<!-- WATER BOTTLES -->
<div class="category-card" data-category="waterbottles">
  <div class="card-carousel-container">
    <div id="carouselWaterbottles" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselWaterbottles" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselWaterbottles" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselWaterbottles" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselWaterbottles" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/waterbottles/waterbottle1.jpg" class="d-block w-100" alt="Water Bottle 1"></div>
        <div class="carousel-item"><img src="img/products/waterbottles/waterbottle2.jpg" class="d-block w-100" alt="Water Bottle 2"></div>
        <div class="carousel-item"><img src="img/products/waterbottles/waterbottle3.jpg" class="d-block w-100" alt="Water Bottle 3"></div>
        <div class="carousel-item"><img src="img/products/waterbottles/waterbottle4.jpg" class="d-block w-100" alt="Water Bottle 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselWaterbottles" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselWaterbottles" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Water Bottles</h3>
  <a href="CategoryServlet?category=Bottles" class="btn btn-info">View More</a>
</div>
<!-- ACCESSORIES -->
<div class="category-card" data-category="accessories">
  <div class="card-carousel-container">
    <div id="carouselAccessories" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselAccessories" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselAccessories" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselAccessories" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselAccessories" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/accessories/accessory1.jpg" class="d-block w-100" alt="Accessory 1"></div>
        <div class="carousel-item"><img src="img/products/accessories/accessory2.jpg" class="d-block w-100" alt="Accessory 2"></div>
        <div class="carousel-item"><img src="img/products/accessories/accessory3.jpg" class="d-block w-100" alt="Accessory 3"></div>
        <div class="carousel-item"><img src="img/products/accessories/accessory4.jpg" class="d-block w-100" alt="Accessory 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselAccessories" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselAccessories" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Accessories</h3>
  <a href="CategoryServlet?category=Accessories" class="btn btn-info">View More</a>
</div>

<!-- MUSICAL INSTRUMENTS -->
<div class="category-card" data-category="musicalinstruments">
  <div class="card-carousel-container">
    <div id="carouselMusical" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselMusical" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselMusical" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselMusical" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselMusical" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/musicalinstruments/musicalinstrument1.jpg" class="d-block w-100" alt="Musical Instrument 1"></div>
        <div class="carousel-item"><img src="img/products/musicalinstruments/musicalinstrument2.jpg" class="d-block w-100" alt="Musical Instrument 2"></div>
        <div class="carousel-item"><img src="img/products/musicalinstruments/musicalinstrument3.jpg" class="d-block w-100" alt="Musical Instrument 3"></div>
        <div class="carousel-item"><img src="img/products/musicalinstruments/musicalinstrument4.jpg" class="d-block w-100" alt="Musical Instrument 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselMusical" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselMusical" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Musical Instruments</h3>
  <a href="CategoryServlet?category=Musicalinstruments" class="btn btn-info">View More</a>
</div>

<!-- PROJECT KITS -->
<div class="category-card" data-category="projectkits">
  <div class="card-carousel-container">
    <div id="carouselProjectKits" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselProjectKits" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselProjectKits" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselProjectKits" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselProjectKits" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/projectkits/projectkit1.jpg" class="d-block w-100" alt="Project Kit 1"></div>
        <div class="carousel-item"><img src="img/products/projectkits/projectkit2.jpg" class="d-block w-100" alt="Project Kit 2"></div>
        <div class="carousel-item"><img src="img/products/projectkits/projectkit3.jpg" class="d-block w-100" alt="Project Kit 3"></div>
        <div class="carousel-item"><img src="img/products/projectkits/projectkit4.jpg" class="d-block w-100" alt="Project Kit 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselProjectKits" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselProjectKits" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Project Kits</h3>
  <a href="CategoryServlet?category=ProjectKits" class="btn btn-info">View More</a>
</div>

<!-- STUDY TABLES -->
<div class="category-card" data-category="studytables">
  <div class="card-carousel-container">
    <div id="carouselStudyTables" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselStudyTables" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselStudyTables" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselStudyTables" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselStudyTables" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/studytables/studytable1.jpg" class="d-block w-100" alt="Study Table 1"></div>
        <div class="carousel-item"><img src="img/products/studytables/studytable2.jpg" class="d-block w-100" alt="Study Table 2"></div>
        <div class="carousel-item"><img src="img/products/studytables/studytable3.jpg" class="d-block w-100" alt="Study Table 3"></div>
        <div class="carousel-item"><img src="img/products/studytables/studytable4.jpg" class="d-block w-100" alt="Study Table 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselStudyTables" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselStudyTables" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Study Tables</h3>
  <a href="CategoryServlet?category=StudyTables" class="btn btn-info">View More</a>
</div>

<!-- DECOR ITEMS -->
<div class="category-card" data-category="decoritems">
  <div class="card-carousel-container">
    <div id="carouselDecorItems" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselDecorItems" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselDecorItems" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselDecorItems" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselDecorItems" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/decoritems/decoritem1.jpg" class="d-block w-100" alt="Decor Item 1"></div>
        <div class="carousel-item"><img src="img/products/decoritems/decoritem2.jpg" class="d-block w-100" alt="Decor Item 2"></div>
        <div class="carousel-item"><img src="img/products/decoritems/decoritem3.jpg" class="d-block w-100" alt="Decor Item 3"></div>
        <div class="carousel-item"><img src="img/products/decoritems/decoritem4.jpg" class="d-block w-100" alt="Decor Item 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselDecorItems" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselDecorItems" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Decor Items</h3>
  <a href="CategoryServlet?category=DecorItems" class="btn btn-info">View More</a>
</div>

<!-- PERFUMES -->
<div class="category-card" data-category="perfumes">
  <div class="card-carousel-container">
    <div id="carouselPerfumes" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselPerfumes" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselPerfumes" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselPerfumes" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselPerfumes" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/perfumes/perfume1.jpg" class="d-block w-100" alt="Perfume 1"></div>
        <div class="carousel-item"><img src="img/products/perfumes/perfume2.jpg" class="d-block w-100" alt="Perfume 2"></div>
        <div class="carousel-item"><img src="img/products/perfumes/perfume3.jpg" class="d-block w-100" alt="Perfume 3"></div>
        <div class="carousel-item"><img src="img/products/perfumes/perfume4.jpg" class="d-block w-100" alt="Perfume 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselPerfumes" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselPerfumes" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Perfumes</h3>
  <a href="CategoryServlet?category=Perfumes" class="btn btn-info">View More</a>
</div>

<!-- PRINTERS -->
<div class="category-card" data-category="printers">
  <div class="card-carousel-container">
    <div id="carouselPrinters" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselPrinters" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselPrinters" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselPrinters" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselPrinters" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/printers/printer1.jpg" class="d-block w-100" alt="Printer 1"></div>
        <div class="carousel-item"><img src="img/products/printers/printer2.jpg" class="d-block w-100" alt="Printer 2"></div>
        <div class="carousel-item"><img src="img/products/printers/printer3.jpg" class="d-block w-100" alt="Printer 3"></div>
        <div class="carousel-item"><img src="img/products/printers/printer4.jpg" class="d-block w-100" alt="Printer 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselPrinters" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselPrinters" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Printers</h3>
  <a href="CategoryServlet?category=Printers" class="btn btn-info">View More</a>
</div>

<!-- TABLE FANS -->
<div class="category-card" data-category="tablefans">
  <div class="card-carousel-container">
    <div id="carouselTableFans" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselTableFans" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselTableFans" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselTableFans" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselTableFans" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/tablefans/tablefan1.jpg" class="d-block w-100" alt="Table Fan 1"></div>
        <div class="carousel-item"><img src="img/products/tablefans/tablefan2.jpg" class="d-block w-100" alt="Table Fan 2"></div>
        <div class="carousel-item"><img src="img/products/tablefans/tablefan3.jpg" class="d-block w-100" alt="Table Fan 3"></div>
        <div class="carousel-item"><img src="img/products/tablefans/tablefan4.jpg" class="d-block w-100" alt="Table Fan 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselTableFans" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselTableFans" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Table Fans</h3>
  <a href="CategoryServlet?category=TableFans" class="btn btn-info">View More</a>
</div>
<!-- Bedsheets -->
<div class="category-card" data-category="bedsheets">
  <div class="card-carousel-container">
    <div id="carouselBedsheets" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselBedsheets" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselBedsheets" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselBedsheets" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselBedsheets" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/bedsheets/bedsheet1.jpg" class="d-block w-100" alt="Bedsheet 1"></div>
        <div class="carousel-item"><img src="img/products/bedsheets/bedsheet2.jpg" class="d-block w-100" alt="Bedsheet 2"></div>
        <div class="carousel-item"><img src="img/products/bedsheets/bedsheet3.jpg" class="d-block w-100" alt="Bedsheet 3"></div>
        <div class="carousel-item"><img src="img/products/bedsheets/bedsheet4.jpg" class="d-block w-100" alt="Bedsheet 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselBedsheets" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselBedsheets" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Bedsheets</h3>
  <a href="CategoryServlet?category=Bedsheets" class="btn btn-info">View More</a>
</div>

<!-- Mugs -->
<div class="category-card" data-category="mugs">
  <div class="card-carousel-container">
    <div id="carouselMugs" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselMugs" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselMugs" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselMugs" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselMugs" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/mugs/mug1.jpg" class="d-block w-100" alt="Mug 1"></div>
        <div class="carousel-item"><img src="img/products/mugs/mug2.jpg" class="d-block w-100" alt="Mug 2"></div>
        <div class="carousel-item"><img src="img/products/mugs/mug3.jpg" class="d-block w-100" alt="Mug 3"></div>
        <div class="carousel-item"><img src="img/products/mugs/mug4.jpg" class="d-block w-100" alt="Mug 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselMugs" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselMugs" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Mugs</h3>
  <a href="CategoryServlet?category=Mugs" class="btn btn-info">View More</a>
</div>

<!-- Calculators -->
<div class="category-card" data-category="calculators">
  <div class="card-carousel-container">
    <div id="carouselCalculators" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselCalculators" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselCalculators" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselCalculators" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselCalculators" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/calculators/calculator1.jpg" class="d-block w-100" alt="Calculator 1"></div>
        <div class="carousel-item"><img src="img/products/calculators/calculator2.jpg" class="d-block w-100" alt="Calculator 2"></div>
        <div class="carousel-item"><img src="img/products/calculators/calculator3.jpg" class="d-block w-100" alt="Calculator 3"></div>
        <div class="carousel-item"><img src="img/products/calculators/calculator4.jpg" class="d-block w-100" alt="Calculator 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselCalculators" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselCalculators" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Calculators</h3>
  <a href="CategoryServlet?category=Calculators" class="btn btn-info">View More</a>
</div>

<!-- Keyboards & Mice -->
<div class="category-card" data-category="keyboards-mice">
  <div class="card-carousel-container">
    <div id="carouselKeyboardsMice" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselKeyboardsMice" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselKeyboardsMice" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselKeyboardsMice" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselKeyboardsMice" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/keyboards&mice/keyboard&mouse1.jpg" class="d-block w-100" alt="Keyboard & Mouse 1"></div>
        <div class="carousel-item"><img src="img/products/keyboards&mice/keyboard&mouse2.jpg" class="d-block w-100" alt="Keyboard & Mouse 2"></div>
        <div class="carousel-item"><img src="img/products/keyboards&mice/keyboard&mouse3.jpg" class="d-block w-100" alt="Keyboard & Mouse 3"></div>
        <div class="carousel-item"><img src="img/products/keyboards&mice/keyboard&mouse4.jpg" class="d-block w-100" alt="Keyboard & Mouse 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselKeyboardsMice" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselKeyboardsMice" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Keyboards &amp; Mice</h3>
  <a href="CategoryServlet?category=KeyboardsMice" class="btn btn-info">View More</a>
</div>

<!-- Extension Boards -->
<div class="category-card" data-category="extensionboards">
  <div class="card-carousel-container">
    <div id="carouselExtensionBoards" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselExtensionBoards" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselExtensionBoards" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselExtensionBoards" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselExtensionBoards" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/extensionboards/extensionboard1.jpg" class="d-block w-100" alt="Extension Board 1"></div>
        <div class="carousel-item"><img src="img/products/extensionboards/extensionboard2.jpg" class="d-block w-100" alt="Extension Board 2"></div>
        <div class="carousel-item"><img src="img/products/extensionboards/extensionboard3.jpg" class="d-block w-100" alt="Extension Board 3"></div>
        <div class="carousel-item"><img src="img/products/extensionboards/extensionboard4.jpg" class="d-block w-100" alt="Extension Board 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselExtensionBoards" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselExtensionBoards" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Extension Boards</h3>
  <a href="CategoryServlet?category=ExtensionBoards" class="btn btn-info">View More</a>
</div>

<!-- Beauty Products -->
<div class="category-card" data-category="beautyproducts">
  <div class="card-carousel-container">
    <div id="carouselBeautyproducts" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselBeautyproducts" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselBeautyproducts" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselBeautyproducts" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselBeautyproducts" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/beautyproducts/beautyproduct1.jpg" class="d-block w-100" alt="Beauty Product 1"></div>
        <div class="carousel-item"><img src="img/products/beautyproducts/beautyproduct2.jpg" class="d-block w-100" alt="Beauty Product 2"></div>
        <div class="carousel-item"><img src="img/products/beautyproducts/beautyproduct3.jpg" class="d-block w-100" alt="Beauty Product 3"></div>
        <div class="carousel-item"><img src="img/products/beautyproducts/beautyproduct4.jpg" class="d-block w-100" alt="Beauty Product 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselBeautyproducts" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselBeautyproducts" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Beauty Products</h3>
  <a href="CategoryServlet?category=Beautyproducts" class="btn btn-info">View More</a>
</div>

<!-- Cleaning Essentials -->
<div class="category-card" data-category="cleaningessentials">
  <div class="card-carousel-container">
    <div id="carouselCleaningessentials" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselCleaningessentials" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselCleaningessentials" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselCleaningessentials" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselCleaningessentials" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/cleaningessentials/cleaningessential1.jpg" class="d-block w-100" alt="Cleaning Essential 1"></div>
        <div class="carousel-item"><img src="img/products/cleaningessentials/cleaningessential2.jpg" class="d-block w-100" alt="Cleaning Essential 2"></div>
        <div class="carousel-item"><img src="img/products/cleaningessentials/cleaningessential3.jpg" class="d-block w-100" alt="Cleaning Essential 3"></div>
        <div class="carousel-item"><img src="img/products/cleaningessentials/cleaningessential4.jpg" class="d-block w-100" alt="Cleaning Essential 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselCleaningessentials" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselCleaningessentials" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Cleaning Essentials</h3>
  <a href="CategoryServlet?category=Cleaningessentials" class="btn btn-info">View More</a>
</div>

<!-- Fitness Equipments -->
<div class="category-card" data-category="fitnessequipments">
  <div class="card-carousel-container">
    <div id="carouselFitnessequipments" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselFitnessequipments" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselFitnessequipments" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselFitnessequipments" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselFitnessequipments" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active"><img src="img/products/fitnessequipments/fitnessequipment1.jpg" class="d-block w-100" alt="Fitness Equipment 1"></div>
        <div class="carousel-item"><img src="img/products/fitnessequipments/fitnessequipment2.jpg" class="d-block w-100" alt="Fitness Equipment 2"></div>
        <div class="carousel-item"><img src="img/products/fitnessequipments/fitnessequipment3.jpg" class="d-block w-100" alt="Fitness Equipment 3"></div>
        <div class="carousel-item"><img src="img/products/fitnessequipments/fitnessequipment4.jpg" class="d-block w-100" alt="Fitness Equipment 4"></div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselFitnessequipments" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselFitnessequipments" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Fitness Equipments</h3>
  <a href="CategoryServlet?category=Fitnessequipments" class="btn btn-info">View More</a>
</div>
<!-- Card: Indoor Games -->
<div class="category-card" data-category="indoorgames">
  <div class="card-carousel-container">
    <div id="carouselIndoorgames" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselIndoorgames" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselIndoorgames" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselIndoorgames" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselIndoorgames" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/indoorgames/indoorgame1.jpg" class="d-block w-100" alt="Indoor Game 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/indoorgames/indoorgame2.jpg" class="d-block w-100" alt="Indoor Game 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/indoorgames/indoorgame3.jpg" class="d-block w-100" alt="Indoor Game 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/indoorgames/indoorgame4.jpg" class="d-block w-100" alt="Indoor Game 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselIndoorgames" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselIndoorgames" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Indoor Games</h3>
  <a href="CategoryServlet?category=Indoorgames" class="btn btn-info">View More</a>
</div>

<!-- Card: Kitchen Appliances -->
<div class="category-card" data-category="kitchenappliances">
  <div class="card-carousel-container">
    <div id="carouselKitchenappliances" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselKitchenappliances" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselKitchenappliances" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselKitchenappliances" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselKitchenappliances" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/kitchenappliances/kitchenappliance1.jpg" class="d-block w-100" alt="Kitchen Appliance 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/kitchenappliances/kitchenappliance2.jpg" class="d-block w-100" alt="Kitchen Appliance 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/kitchenappliances/kitchenappliance3.jpg" class="d-block w-100" alt="Kitchen Appliance 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/kitchenappliances/kitchenappliance4.jpg" class="d-block w-100" alt="Kitchen Appliance 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselKitchenappliances" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselKitchenappliances" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Kitchen Appliances</h3>
  <a href="CategoryServlet?category=Kitchenappliances" class="btn btn-info">View More</a>
</div>

<!-- Card: Pet Supplies -->
<div class="category-card" data-category="petsupplies">
  <div class="card-carousel-container">
    <div id="carouselPetsupplies" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselPetsupplies" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselPetsupplies" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselPetsupplies" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselPetsupplies" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/petsupplies/petsupply1.jpg" class="d-block w-100" alt="Pet Supply 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/petsupplies/petsupply2.jpg" class="d-block w-100" alt="Pet Supply 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/petsupplies/petsupply3.jpg" class="d-block w-100" alt="Pet Supply 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/petsupplies/petsupply4.jpg" class="d-block w-100" alt="Pet Supply 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselPetsupplies" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselPetsupplies" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Pet Supplies</h3>
  <a href="CategoryServlet?category=Petsupplies" class="btn btn-info">View More</a>
</div>

<!-- Card: Self Care Products -->
<div class="category-card" data-category="selfcareproducts">
  <div class="card-carousel-container">
    <div id="carouselSelfcareproducts" class="carousel slide" data-bs-ride="carousel" data-bs-pause="hover">
      <div class="carousel-indicators">
        <button type="button" data-bs-target="#carouselSelfcareproducts" data-bs-slide-to="0" class="active"></button>
        <button type="button" data-bs-target="#carouselSelfcareproducts" data-bs-slide-to="1"></button>
        <button type="button" data-bs-target="#carouselSelfcareproducts" data-bs-slide-to="2"></button>
        <button type="button" data-bs-target="#carouselSelfcareproducts" data-bs-slide-to="3"></button>
      </div>
      <div class="carousel-inner">
        <div class="carousel-item active">
          <img src="img/products/selfcareproducts/selfcareproduct1.jpg" class="d-block w-100" alt="Self Care Product 1">
        </div>
        <div class="carousel-item">
          <img src="img/products/selfcareproducts/selfcareproduct2.jpg" class="d-block w-100" alt="Self Care Product 2">
        </div>
        <div class="carousel-item">
          <img src="img/products/selfcareproducts/selfcareproduct3.jpg" class="d-block w-100" alt="Self Care Product 3">
        </div>
        <div class="carousel-item">
          <img src="img/products/selfcareproducts/selfcareproduct4.jpg" class="d-block w-100" alt="Self Care Product 4">
        </div>
      </div>
      <button class="carousel-control-prev" type="button" data-bs-target="#carouselSelfcareproducts" data-bs-slide="prev">
        <span class="carousel-control-prev-icon"></span>
      </button>
      <button class="carousel-control-next" type="button" data-bs-target="#carouselSelfcareproducts" data-bs-slide="next">
        <span class="carousel-control-next-icon"></span>
      </button>
    </div>
  </div>
  <h3>Self Care Products</h3>
  <a href="CategoryServlet?category=Selfcareproducts" class="btn btn-info">View More</a>
</div>


            </div> <!-- end .category-grid -->

            <button id="scrollTopBtn" title="Go to top">↑</button>

        </div> <!-- end .buy-wrapper -->
    </div> <!-- end .page-bg.buy-page -->

    <%@ include file="footer.jsp" %>
    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

    <!--  Carousel Initialization -->
    <script>
        const carousels = [
            { id: '#carouselMobiles', interval: 3000 },
            { id: '#carouselLaptops', interval: 4000 },
            { id: '#carouselBooks', interval: 2500 },
            { id: '#carouselShoes', interval: 5000 },
            { id: '#carouselBags', interval: 3000 },
            { id: '#carouselWatches', interval: 3000 },
            { id: '#carouselStationery', interval: 3000 },
            { id: '#carouselSpeakers', interval: 3000 },
            { id: '#carouselClothes', interval: 3500 },
            { id: '#carouselGaming', interval: 4500 },
            { id: '#carouselHeadphones', interval: 3000 },
            { id: '#carouselFurniture', interval: 4000 },
            { id: '#carouselBicycles', interval: 3000 },
            { id: '#carouselBikes', interval: 3500 },
            { id: '#carouselPowerbanks', interval: 4000 },
            { id: '#carouselSports', interval: 3000 },
            { id: '#carouselEarbuds', interval: 3000 },
            { id: '#carouselWallclocks', interval: 3000 },
            { id: '#carouselLamps', interval: 3000 },
            { id: '#carouselWaterbottles', interval: 3000 },
            { id: '#carouselAccessories', interval: 3000 },
            { id: '#carouselMusicalinstruments', interval: 3000 },
            { id: '#carouselProjectkits', interval: 3000 },
            { id: '#carouselStudytables', interval: 3000 },
            { id: '#carouselDecoritems', interval: 3000 },
            { id: '#carouselPerfumes', interval: 3000 },
            { id: '#carouselPrinters', interval: 3000 },
            { id: '#carouselTablefans', interval: 3000 },
            { id: '#carouselBedsheets', interval: 3000 },
            { id: '#carouselMugs', interval: 3000 },
            { id: '#carouselCalculators', interval: 3000 },
            { id: '#carouselKeyboardsmice', interval: 3000 },
            { id: '#carouselExtensionboards', interval: 3000 },
            { id: '#carouselBeautyproducts', interval: 3000 },
            { id: '#carouselCleaningessentials', interval: 3000 },
            { id: '#carouselFitnessequipments', interval: 3000 },
            { id: '#carouselIndoorgames', interval: 3000 },
            { id: '#carouselKitchenappliances', interval: 3000 },
            { id: '#carouselPetsupplies', interval: 3000 },
            { id: '#carouselSelfcareproducts', interval: 3000 }
        ];

        carousels.forEach(({ id, interval }) => {
            const element = document.querySelector(id);
            if (element) {
                new bootstrap.Carousel(element, {
                    interval: interval,
                    ride: 'carousel',
                    pause: 'hover',
                    wrap: true
                });
            }
        });
    </script>

    <!--  AOS (Scroll Animations) -->
    <script src="https://cdnjs.cloudflare.com/ajax/libs/aos/2.3.4/aos.js"></script>
    <script>
        AOS.init({
            duration: 500,
            once: false,
            mirror: true
        });
    </script>

    <!--  Search & Filter Logic -->
    <script>
        const categories = [
            { label: "Mobiles", value: "mobiles" },
            { label: "Laptops", value: "laptops" },
            { label: "Books", value: "books" },
            { label: "Shoes", value: "shoes" },
            { label: "Bags", value: "bags" },
            { label: "Watches", value: "watches" },
            { label: "Stationery", value: "stationery" },
            { label: "Speakers", value: "speakers" },
            { label: "Clothes", value: "clothes" },
            { label: "Gaming", value: "gaming" },
            { label: "Headphones", value: "headphones" },
            { label: "Furniture", value: "furniture" },
            { label: "Bicycles", value: "bicycles" },
            { label: "Bikes", value: "bikes" },
            { label: "Powerbanks", value: "powerbanks" },
            { label: "Sports", value: "sports" },
            { label: "Earbuds", value: "earbuds" },
            { label: "Wall Clocks", value: "wallclocks" },
            { label: "Lamps", value: "lamps" },
            { label: "Water Bottles", value: "waterbottles" },
            { label: "Accessories", value: "accessories" },
            { label: "Musical Instruments", value: "musicalinstruments" },
            { label: "Project Kits", value: "projectkits" },
            { label: "Study Tables", value: "studytables" },
            { label: "Decor Items", value: "decoritems" },
            { label: "Perfumes", value: "perfumes" },
            { label: "Printers", value: "printers" },
            { label: "Table Fans", value: "tablefans" },
            { label: "Bedsheets", value: "bedsheets" },
            { label: "Mugs", value: "mugs" },
            { label: "Calculators", value: "calculators" },
            { label: "Keyboards & Mice", value: "keyboards&mice" },
            { label: "Extension Boards", value: "extensionboards" },
            { label: "Beauty Products", value: "beautyproducts" },
            { label: "Cleaning Essentials", value: "cleaningessentials" },
            { label: "Fitness Equipments", value: "fitnessequipments" },
            { label: "Indoor Games", value: "indoorgames" },
            { label: "Kitchen Appliances", value: "kitchenappliances" },
            { label: "Pet Supplies", value: "petsupplies" },
            { label: "Self Care Products", value: "selfcareproducts" }
        ];

        function suggestCategory() {
            const input = document.getElementById("smartSearch");
            const filter = input.value.toLowerCase();
            const suggestions = document.getElementById("suggestions");
            suggestions.innerHTML = "";

            if (!filter) {
                suggestions.style.display = "none";
                showAllCards();
                return;
            }

            const matched = categories.filter(cat =>
                cat.label.toLowerCase().includes(filter)
            );

            matched.forEach(cat => {
                const li = document.createElement("li");
                li.classList.add("list-group-item", "list-group-item-action");
                li.textContent = cat.label;
                li.onclick = () => {
                    input.value = cat.label;
                    suggestions.innerHTML = "";
                    suggestions.style.display = "none";
                    filterCardsByCategory(cat.value);
                };
                suggestions.appendChild(li);
            });

            suggestions.style.display = matched.length > 0 ? "block" : "none";
        }

        function filterCardsByCategory(category) {
            const cards = document.querySelectorAll(".category-card");
            cards.forEach(card => {
                const dataCat = (card.getAttribute("data-category") || "").toLowerCase();
                card.style.display = (dataCat === category) ? "block" : "none";
            });
        }

        function showAllCards() {
            document.querySelectorAll(".category-card").forEach(card => {
                card.style.display = "block";
            });
        }
    </script>

    <!--  Keyboard Navigation for Suggestions -->
    <script>
        let currentFocus = -1;

        document.getElementById("smartSearch").addEventListener("keydown", function(e) {
            const suggestions = document.getElementById("suggestions");
            let items = suggestions.getElementsByTagName("li");

            if (e.key === "ArrowDown") {
                currentFocus++;
                addActive(items);
            } else if (e.key === "ArrowUp") {
                currentFocus--;
                addActive(items);
            } else if (e.key === "Enter") {
                e.preventDefault();
                if (currentFocus > -1 && items[currentFocus]) {
                    items[currentFocus].click();
                }
            } else if (e.key === "Escape") {
                suggestions.style.display = "none";
                currentFocus = -1;
            }
        });

        function addActive(items) {
            if (!items || items.length === 0) return;

            removeActive(items);

            if (currentFocus >= items.length) currentFocus = 0;
            if (currentFocus < 0) currentFocus = items.length - 1;

            items[currentFocus].classList.add("active-suggestion");
            items[currentFocus].scrollIntoView({ block: "center", behavior: "smooth" });
        }

        function removeActive(items) {
            for (let i = 0; i < items.length; i++) {
                items[i].classList.remove("active-suggestion");
            }
        }
    </script>

    <!--  Pause carousels on hover -->
    <script>
        document.addEventListener('DOMContentLoaded', function () {
            const cards = document.querySelectorAll('.category-card');

            cards.forEach(card => {
                const carousel = card.querySelector('.carousel');

                if (carousel) {
                    const bsCarousel = bootstrap.Carousel.getOrCreateInstance(carousel, {
                        interval: 2000,
                        pause: false
                    });

                    card.addEventListener('mouseenter', () => {
                        bsCarousel.pause();
                    });

                    card.addEventListener('mouseleave', () => {
                        bsCarousel.cycle();
                    });
                }
            });
        });
    </script>

    <!-- Scroll-to-top button -->
    <script>
        const scrollBtn = document.getElementById("scrollTopBtn");

        window.onscroll = function () {
            scrollBtn.style.display = (document.body.scrollTop > 300 || document.documentElement.scrollTop > 300)
                ? "block"
                : "none";
        };

        scrollBtn.onclick = function () {
            window.scrollTo({ top: 0, behavior: 'smooth' });
        };
    </script>

</body>
</html>