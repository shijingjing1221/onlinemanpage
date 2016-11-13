  $(document).ready(function() {
      function checkKey(event) {
          event.preventDefault();
          if (event.keyCode == 13) {
              document.getElementById("myBtn").click();
          }
      }

      function myFunction() {
          // Declare variables 
          var input, re, table, tr, td, i;
          input = document.getElementById("myInput").value;
          re = new RegExp(input, '');
          table = document.getElementById("myTable");
          tr = table.getElementsByTagName("tr");

          // Loop through all table rows, and hide those who don't match the search query
          for (i = 0; i < tr.length; i++) {
              td = tr[i].getElementsByTagName("td")[1];
              if (td) {
                  if (re.test(td.childNodes[0].text)) {
                      tr[i].style.display = "";
                  } else {
                      tr[i].style.display = "none";
                  }
              }
          }
      }
  });