<!-- Improved compatibility of back to top link: See: https://github.com/othneildrew/Best-README-Template/pull/73 -->
<a name="readme-top"></a>
<!--
*** Thanks for checking out the Best-README-Template. If you have a suggestion
*** that would make this better, please fork the repo and create a pull request
*** or simply open an issue with the tag "enhancement".
*** Don't forget to give the project a star!
*** Thanks again! Now go create something AMAZING! :D
-->


<!-- PROJECT SHIELDS -->
<!--
*** I'm using markdown "reference style" links for readability.
*** Reference links are enclosed in brackets [ ] instead of parentheses ( ).
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->
<!-- PROJECT LOGO -->

<br />
<div align="center">
  <a href="https://github.com/Bobsters986/psydiary_back_end">
    <img src="https://user-images.githubusercontent.com/114954379/233477958-2d09ebc7-8585-4d78-8f5b-381fd976447c.png" height="200">
  </a>

  <h3 align="center">🍄 Psydiary—The App to Bring You Home 🍄</h3>

  <p align="center">
    An app to track your psilocybin microdosing protocol with everything from daily mood metrics and monthly trend representation to AI generated journal prompts.
    <br />
  </p>
</div>



<!-- TABLE OF CONTENTS -->
<details>
  <summary>Table of Contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">About The Project</a>
      <ul>
        <li><a href="#built-with">Built With</a></li>
      </ul>
    </li>
    <li>
      <a href="#getting-started">Getting Started</a>
      <ul>
        <li><a href="#prerequisites">Prerequisites</a></li>
        <li><a href="#installation">Installation</a></li>
      </ul>
    </li>
    <li><a href="#screenshots">Screenshots</a></li>
    <li><a href="#roadmap">Roadmap</a></li>
    <li><a href="#contributing">Contributing</a></li>
    <li><a href="#license">License</a></li>
    <li><a href="#projects">Project Links</a></li>
    <li><a href="#acknowledgments">Acknowledgments</a></li>
  </ol>
</details>



## About The Project

Psydiary is a web application for users to track and journal their experiences with microdosing psychedelic mushrooms. The self reflection and data a user gathers on themselves is crucial to their journey. It will help them know what's working, if it’s time to change the frequency of their microdosing routine, or if they need a break from microdosing altogether. Users can document the following daily metrics;

* Mood
* Sleep Quality
* Anxiety Score
* Depression Score
* Energy Levels
* Sociability
* Meditation Time
* Exercise Type

Users can also gain insight from their microdose protocols and journal their experience through tracking;
* Dosage
* Intensity
* Mood Before and After
* Environment
* Sociability
* An AI generated journal prompt you can respond to

Psydiary hopes to provide a structured way for users to track their experience with self-guided-treatment.

### Psydiary Back End API

* This repo serves as an API and Database storage for our application's Microdose Protocols, Users, and user's log entries.
* It consumes the IPGeolocation API, which we used to validate the location of our users before before they can create an account. This ensures the potential user resides in a state where psilocybin is is legal.

<p align="right">(<a href="#readme-top">back to top</a>)</p>


### Built With

To build this web application, our team utilized;

* Ruby 3.1.1
* Rails 7.0.4.3
* PostgreSQL
* Bootstrap
* Heroku
* New Relic


<p align="right">(<a href="#readme-top">back to top</a>)</p>



## Getting Started
<!-- can change this later or add more detail -->

### Prerequisites

* Ruby
  ```sh
  Ruby 3.1.1
  ```

* Rails
  ```sh
  Rails 7.0.4.3
  ```

### Installation

_Follow the steps below to install and set up this app._

1. NEEDS a IPGEOLOCATION API KEY. Get a free API Key at [https://ipgeolocation.io/](https://ipgeolocation.io/)
2. Clone this Repository
   ```sh
   git clone https://github.com/Bobsters986/psydiary_back_end
   ```
3. In your terminal, run the following commands;
    ```sh
    bundle install
    bundle exec figaro install
    rails db:{drop,create,migrate,seed}
    ```
4. Enter your IPGeolocaiton API key in `application.yml`
   ```ruby
   ipgeo_api_key: 'ENTER YOUR API';
   ```

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- USAGE EXAMPLES -->
## Screenshots

### Schema

Schema: <img src= "https://user-images.githubusercontent.com/116703107/233485522-12c89f31-219f-46fb-9a45-ad508f49183c.png" height="300" width="400">


<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- Testing -->
## Testing

* This project utilizes RSpec testing
* After cloning this repo and following the steps above to install all necessary gems and API keys:
** Run the entire test suite using the command `bundle exec rspec`

<!-- JSON Contract -->
### JSON contract/endpoints

JSON Contract Gist: [https://gist.github.com/4D-Coder/72e8d31c4b2b266d8f7ec95a7e411295](https://gist.github.com/4D-Coder/72e8d31c4b2b266d8f7ec95a7e411295)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- ROADMAP -->
## Roadmap

- [x] Add README
- [x] Add Root Page
- [ ] Add Learn More Page
- [x] Add New User Page
- [x] Add User Login
- [x] User Dashboard
- [x] Protocol Show Page
- [x] User Edit Page
- [x] New Daily Log
- [x] New Microdose Diary
- [x] Daily Log/Microdose Index
- [x] Daily Log Show Page
- [x] Dose Show Page
- [ ] Resources/Discover Page

<p align="right">(<a href="#readme-top">back to top</a>)</p>



<!-- CONTRIBUTING -->
## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<p align="right">(<a href="#readme-top">back to top</a>)</p>


<!-- CONTACT -->
## Projects

Back End Project Link: [https://github.com/Psydiary/psydiary_back_end](https://github.com/Psydiary/psydiary_back_end)
Back End Heroku: [https://dashboard.heroku.com/apps/pacific-reef-79035](https://dashboard.heroku.com/apps/pacific-reef-79035)

Front End Project Link: [https://github.com/Psydiary/psydiary_front_end](https://github.com/Psydiary/psydiary_front_end)
Front End Heroku: [https://secure-crag-03925.herokuapp.com/](https://secure-crag-03925.herokuapp.com/)

<p align="right">(<a href="#readme-top">back to top</a>)</p>


## Contributors

### PsyDiary Team
<table>
  <tr>
    <td><img src="https://avatars.githubusercontent.com/torienyart"></td>
    <td><img src="https://avatars.githubusercontent.com/Bobsters986"></td>
    <td><img src="https://avatars.githubusercontent.com/4D-Coder"></td>
    <td><img src="https://avatars.githubusercontent.com/davejm8"></td>
    <td><img src="https://avatars.githubusercontent.com/sgwalker327"></td>
  </tr>
  <tr>
    <td>Tori Enyart</td>
    <td>Bobby Luly</td>
    <td>Antonio King Hunt</td>
    <td>David Marino</td>
    <td>Sam Walker</td>
  </tr>
  <tr>
    <td>
      <a href="https://github.com/torienyart">GitHub</a><br>
      <a href="https://www.linkedin.com/in/victoria-enyart-595052155/">LinkedIn</a>
    </td>
    <td>
      <a href="https://github.com/Bobsters986">GitHub</a><br>
      <a href="https://www.linkedin.com/in/bobbyy-luly-217653260/">LinkedIn</a>
    </td>
    <td>
      <a href="https://github.com/4D-Coder">GitHub</a><br>
      <a href="https://www.linkedin.com/in/antoniokinghunt/">LinkedIn</a>
    </td>
    <td>
      <a href="https://github.com/davejm8">GitHub</a><br>
      <a href="https://www.linkedin.com/in/davidjmarino8/">LinkedIn</a>
    </td>
    <td>
      <a href="https://github.com/sgwalker327">GitHub</a><br>
      <a href="https://www.linkedin.com/in/sam-walker-95a49630/">LinkedIn</a>
    </td>
  </tr>
</table>
