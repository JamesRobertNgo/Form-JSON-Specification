(function buildForm() {
	var placeholder = document.getElementById("PLACEHOLDER");
	
	var form = document.createElement('form');
	form.setAttribute('id', 'form_' + "FORM_ID_1");
	form.setAttribute('action', "ACTON");
	form.setAttribute('method', "METHOD");
	form.setAttribute("required", "required");
	form.setAttribute("class", "sampleClass1, sampleClass2");
	form.setAttribute("autocomplete", "true");
	
	(function(form) {
		var data = {
			"id": "FORMMOD_ID_1",
			"data": "<h1>My Form</h1><p>Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam tempus lorem tempus risus semper rhoncus. Donec id vulputate nibh. Cras fringilla arcu erat, eget tristique metus laoreet vitae. Cras auctor, purus sit amet laoreet lobortis, urna tellus consequat lectus, et bibendum nunc nisi at dolor. Nam et tristique eros. Maecenas ut eleifend est, eget malesuada metus. Maecenas semper hendrerit tristique. Donec eget luctus arcu. Etiam sed enim laoreet nisi gravida tempus vestibulum nec ligula. Aenean vulputate dapibus sapien eget consequat. Ut tristique semper enim eget elementum. Sed sagittis purus suscipit elit volutpat porta. Nulla tincidunt egestas velit. Phasellus bibendum congue rhoncus. Phasellus feugiat enim eget dignissim tincidunt. Interdum et malesuada fames ac ante ipsum primis in faucibus.</p>",
			"typeCode": "HTML"
		};
		var code = function(data, form) {
			var data = arguments[0];
			var form = arguments[1];
			var div = document.createElement('div');
			div.setAttribute('id', data.typeCode + '_' + data.id);
			div.innerHTML = data.data;
			form.appendChild(div);
		};
		code(data, form);
	})(form);
	
	(function(parent, form) {
		var data = {
			"id": "ELEMENT_ID_1",
			"name": "NAME",
			"label": "LABEL",
			"typeCode": "TEXT"
		};
		
		var elementCode = function(data, parent, form) {
			var data = arguments[0];
			var parent = arguments[1];
			var form = arguments[2];
			var p = document.createElement('p');
			var label = document.createElement('label');
			label.innerHTML = data.label;
			p.appendChild(label);
			var input = document.createElement('input');
			input.setAttribute('type', 'text');
			input.setAttribute('id', data.typeCode + '_' + data.id);
			p.appendChild(input);
			parent.appendChild(p);
			return p;
		};
		
		var element = elementCode(data, parent, form);
		
		var attributeCode = function(element) {
			var element = arguments[0];
			var attributeElement = element.getElementsByTagName('input')[0];
			return attributeElement;
		};
		
		var attributeElement = attributeCode(element);
		attributeElement.setAttribute("required", "required");
		
		(function(element, form) {
			var data = {
				"id": "ELEMENTMOD_ID_1",
				"data": "DATA",
				"typeCode": "ALERT"
			};
			var code = function(data, form) {
				alert('hello world');
			};
			code(data, element, form);
		})(element, form);
	})(form, form);
	
	(function(parent, form) {
		var data = {
			"id": "ELEMENT_ID_2",
			"name": "NAME",
			"label": "LABEL",
			"typeCode": "SELECT"
		};
		
		var elementCode = function(data, parent, form) {
			var data = arguments[0];
			var parent = arguments[1];
			var form = arguments[2];
			var p = document.createElement('p');
			var label = document.createElement('label');
			label.innerHTML = data.label;
			p.appendChild(label);
			var select = document.createElement('select');
			select.setAttribute('id', data.typeCode + '_' + data.id);
			p.appendChild(select);
			parent.appendChild(p);
			return p;
		};
		
		var element = elementCode(data, parent, form);
		
		var attributeCode = function(element) {
			var element = arguments[0];
			var attributeElement = element.getElementsByTagName('select')[0];
			return attributeElement;
		};
		
		var attributeElement = attributeCode(element);
		attributeElement.setAttribute("class", "sampleClass1, sampleClass2");
		
		(function(parent, form) {
			var data = {
				"id": "ELEMENT_ID_3",
				"name": "NAME",
				"label": "Option1",
				"typeCode": "OPTION"
			};
			
			var elementCode = function(data, parent, form) {
				var data = arguments[0];
				var parent = arguments[1];
				var form = arguments[2]; /*Need to look into this*/
				var select = parent.getElementsByTagName('select')[0];
				var option = document.createElement('option');
				option.innerHTML = data.label;
				select.appendChild(option);
				return option;
			};
			
			var element = elementCode(data, parent, form);
			
			var attributeCode = function(element) {
				return element
			};
			
			var attributeElement = attributeCode(element);
		})(element, form);
	})(form, form);
	
	(function(form) {
		var p = document.createElement('p');
		p.setAttribute('id', 'form_' + "FORM_ID_1" + '_buttons');
		
		var submit = document.createElement('input');
		submit.setAttribute('type', 'submit');
		
		p.appendChild(submit);
		
		var reset = document.createElement('input');
		reset.setAttribute('type', 'reset');
		
		p.appendChild(reset);
		
		form.appendChild(p);
	})(form);
	
	placeholder.appendChild(form);
})();