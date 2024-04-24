function ChangeColor() {
  var body = document.getElementById("bodyColor");
  var currentColor = body.style.backgroundColor;
  
  // Check if the background color is set
  if (currentColor === "" || currentColor === "FloralWhite") {
    // Change the background color to a different color
    body.style.backgroundColor = "lightblue";
  } else {
    // Revert back to the original background color
    body.style.backgroundColor = "FloralWhite";
  }
}
