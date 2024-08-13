function ChangeColor() {
  var body = document.getElementById("bodyColor");
  var currentColor = window.getComputedStyle(body, null).backgroundColor;
  
  // Check if the background color is set to lightblue
  if (currentColor === "rgb(255, 250, 240)" || currentColor === "floralwhite") {
    // Change the background color to a different color
    body.style.backgroundColor = "lightblue";
  } else {
    // Revert back to the original background color
    body.style.backgroundColor = "FloralWhite";
  }
}
