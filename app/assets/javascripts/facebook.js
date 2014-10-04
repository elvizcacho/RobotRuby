

	window.fbAsyncInit = function() {
        FB.init({
          appId      : '600333230058614',
          xfbml      : true,
          version    : 'v2.1'
        });

        FB.getLoginStatus(function(response) {
          if (response.status === 'connected') {
            console.log('Logged in.');
          }
          else {
            FB.login();
          }
        });
  };

      (function(d, s, id){
         var js, fjs = d.getElementsByTagName(s)[0];
         if (d.getElementById(id)) {return;}
         js = d.createElement(s); js.id = id;
         js.src = "http://connect.facebook.net/en_US/sdk.js";
         fjs.parentNode.insertBefore(js, fjs);
       }(document, 'script', 'facebook-jssdk'));


    