HTMLWidgets.widget({

  name: 'KronaR',

  type: 'output',

  factory: function(el, width, height) {

    return {

      renderValue: function(x) {
        // Clear previous contents
        while (el.firstChild) {
          el.removeChild(el.firstChild);
        }

        // Set size constraints for the widget container element (el)
        el.style.width = '600px';  // Set desired width
        el.style.height = '400px'; // Set desired height
        el.style.position = 'relative';
        el.style.overflow = 'hidden';  // Hide overflow if needed

        var dataKrona = x.message;

        // Set up Krona data and load it in the `el` container
        var datel = document.createElement("Krona");
        datel.setAttribute("collapse", "true");
        datel.setAttribute("key", "true");
        datel.innerHTML = dataKrona;

        var div = document.createElement("div");
        div.setAttribute("style", "display:none");
        div.appendChild(datel);

        el.appendChild(div);  // Append to `el`, not to `document.body`

        // Load the visualization
        load();
      },

      resize: function(width, height) {
        // Apply size adjustments if the widget is resized
        el.style.width = width + 'px';
        el.style.height = height + 'px';
      }
    };
  }
});
