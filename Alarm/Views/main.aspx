<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="main.aspx.cs" Inherits="Alarm.Views.main" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Alarm App</title>
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" />
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.5.1/jquery.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.16.0/umd/popper.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container mt-5">
        <h1 class="mb-4">Alarm App</h1>

        <div class="card">
            <div class="card-body">
                <h5 class="card-title">Add Alarm</h5>
                <div class="form-group">
                    <label for="txtTime">Time:</label>
                    <input type="datetime-local" id="txtTime" class="form-control" required="required" step="1" />
                    <div class="invalid-feedback">Please enter a time.</div>
                </div>
                <div class="form-group">
                    <label for="txtName">Name:</label>
                    <input type="text" id="txtName" class="form-control" required="required" />
                </div>
                <button type="button" class="btn btn-primary" onclick="addAlarm()">Add Alarm</button>
            </div>
        </div>

        <div class="card mt-4">
            <div class="card-body">
                <h5 class="card-title">Alarms</h5>
                <ul id="alarmList" class="list-group">
                </ul>
            </div>
        </div>

        <div id="alarmMessage" class="alert alert-success mt-4" style="display: none;">
            It's time for your alarm!
        </div>

        <div class="mt-4">
            <asp:Label ID="lblMessage" runat="server" CssClass="alert" EnableViewState="false"></asp:Label>
        </div>
    </div>
    <!-- Formulario de edición (se muestra dinámicamente) -->
    <div id="editForm" class="modal fade" tabindex="-1" role="dialog" aria-labelledby="editFormLabel" aria-hidden="true">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="editFormLabel">Edit Alarm</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                    <div class="form-group">
                        <label for="editTxtTime">Time:</label>
                        <input type="datetime-local" id="editTxtTime" class="form-control" required="required" step="1" />
                        <div class="invalid-feedback">Please enter a time.</div>
                    </div>
                    <div class="form-group">
                        <label for="editTxtName">Name:</label>
                        <input type="text" id="editTxtName" class="form-control" required="required" />
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                    <button type="button" class="btn btn-primary" onclick="saveChanges()">Save changes</button>
                </div>
            </div>
        </div>
    </div>

    <script type="text/javascript">
        var alarms = []; // Array que inicia y almacena nuestras alarmas
        var editIndex = -1;
        var alarmTimeouts = {};
        // Hacemos nuestra funcion para agregar una nueva alarma
        function addAlarm() {
            var timeInput = document.getElementById("txtTime").value; //valores que viene del html
            var name = document.getElementById("txtName").value;//valores que viene del html
            var days = [];
            var checkboxes = document.getElementsByName("chkDay"); //valor que quisimos agregar pero mejor utilzamos un modal
            for (var i = 0; i < checkboxes.length; i++) {
                if (checkboxes[i].checked) {
                    days.push(checkboxes[i].value); // no hace nada este for lo agregamos para otra cosa pero lo dejamos aca
                }
            }

            var alarmTime = new Date(timeInput); 
            var currentTime = new Date();

            if (alarmTime <= currentTime) {
                alert("Please select a future time for the alarm."); //nuestro mensaje para que ponga una alarma al futuro
                return;
            }

            //los valores de la alarma nueva
            var newAlarm = {
                Time: timeInput,
                Name: name, 
                Days: days,
                IsActive: true
            };

            alarms.push(newAlarm); // Agregamos la nueva alarma al array

            updateAlarmList(); // Actualizamos la lista de alarmas en el UI

            var timeDifference = alarmTime.getTime() - currentTime.getTime();

            setTimeout(function () {
                alert("Alarm: " + newAlarm.Name);
            }, timeDifference);

            // Limpiamos los campos despues de agregar la alarma
            document.getElementById("txtTime").value = "";
            document.getElementById("txtName").value = "";
            for (var i = 0; i < checkboxes.length; i++) {
                checkboxes[i].checked = false;
            }
        }

        // abramos el modal para editar
        function openEditForm(index) {
            var alarm = alarms[index];
            document.getElementById("editTxtTime").value = alarm.Time;
            document.getElementById("editTxtName").value = alarm.Name;
            $('#editForm').modal('show');
            editIndex = index; // Aqui lo agregamos al array el index
        }

        // Guardamos los cambios en la alarma
        function saveChanges() {
            if (editIndex !== -1) {
                var editedAlarm = alarms[editIndex];
                var originalAlarmName = editedAlarm.Name;

                // Cancelar el temporizador anterior si existe
                if (alarmTimeouts[originalAlarmName]) {
                    clearTimeout(alarmTimeouts[originalAlarmName]);
                    delete alarmTimeouts[originalAlarmName];
                }

                var newAlarmName = document.getElementById("editTxtName").value;

                // Eliminamos la alarma original
                alarms.splice(editIndex, 1);

                // Creamos una nueva alarma con los camios
                var newAlarm = {
                    Time: document.getElementById("editTxtTime").value,
                    Name: newAlarmName,
                    Days: [],
                    IsActive: editedAlarm.IsActive
                };

                // Esto no lo estamos utilizando porque no estamos usando dias
                //var editedDays = [];
                //var editCheckboxes = document.getElementsByName("editChkDay");
                //for (var i = 0; i < editCheckboxes.length; i++) {
                    //if (editCheckboxes[i].checked) {
                        //editedDays.push(editCheckboxes[i].value);
                    //}
                //}
                //newAlarm.Days = editedDays;

                // Agregamos la nueva alarma al array
                alarms.push(newAlarm);

                // Restablecemos editIndex
                editIndex = -1;

                // Actualizamos la lista en la UI
                updateAlarmList();

                // Aquí es donde debemos ajustar el tiempo de la nueva alarma si está activa
                if (newAlarm.IsActive) {
                    var alarmTime = new Date(newAlarm.Time);
                    var currentTime = new Date();
                    var timeDifference = alarmTime.getTime() - currentTime.getTime();

                    // Establecemos un nuevo temporizador para la nueva alarma
                    alarmTimeouts[newAlarm.Name] = setTimeout(function () {
                        alert("Alarm: " + newAlarm.Name);
                    }, timeDifference);
                }

                $('#editForm').modal('hide');
            }
        }

        // Actualizamos la alarma en el UI tambien
        function updateAlarmList() {
            var alarmList = document.getElementById("alarmList");
            alarmList.innerHTML = "";
            for (var i = 0; i < alarms.length; i++) {
                var alarm = alarms[i];
                var listItem = document.createElement("li");
                listItem.textContent = "Name: " + alarm.Name + ", Time: " + alarm.Time + ", Days: " + alarm.Days.join(", ");
                listItem.className = "list-group-item";
                var editButton = document.createElement("button");
                editButton.textContent = "Edit";
                editButton.className = "btn btn-primary btn-sm float-right mr-2";
                editButton.onclick = function (index) {
                    return function () {
                        openEditForm(index);
                    };
                }(i);
                listItem.appendChild(editButton);
                // variables para nuestro boton de delete
                var deleteButton = document.createElement("button");
                deleteButton.textContent = "Delete";
                deleteButton.className = "btn btn-danger btn-sm float-right ml-2";
                deleteButton.onclick = function (index) {
                    return function () {
                        removeAlarm(index); // aca lo removamos
                    };
                }(i);
                listItem.appendChild(deleteButton);
                // Botón de disable
                var toggleButton = document.createElement("button");
                toggleButton.textContent = alarm.IsActive ? "Disable" : "Enable";
                toggleButton.className = "btn btn-secondary btn-sm float-right ml-2";
                toggleButton.onclick = function (alarm, toggleButton) {
                    return function () {
                        toggleAlarm(alarm, toggleButton);
                    };
                }(alarm, toggleButton);
                listItem.appendChild(toggleButton);

                // agregamos el elemento de la lista a la lista de alarmas
                alarmList.appendChild(listItem);
            }
        }

        // Función para eliminar una alarma
        function removeAlarm(index) {
            var removedAlarm = alarms.splice(index, 1)[0]; 
            clearTimeout(alarmTimeouts[removedAlarm.Name]); 
            delete alarmTimeouts[removedAlarm.Name]; 
            updateAlarmList(); 
        }

        // Función para activar o desactivar una alarma
        function toggleAlarm(alarm, toggleButton) {
            if (alarm.IsActive) {
                // Si la alarma está activa, la desactivamos
                alarm.IsActive = false;
                clearTimeout(alarmTimeouts[alarm.Name]); 
                delete alarmTimeouts[alarm.Name]; 
                toggleButton.textContent = "Enable"; 
                toggleButton.classList.remove("btn-danger"); 
                toggleButton.classList.add("btn-secondary"); 
            } else {
                // Si la alarma está desactivada, la activamos
                alarm.IsActive = true;
                var alarmTime = new Date(alarm.Time);
                var currentTime = new Date();
                var timeDifference = alarmTime.getTime() - currentTime.getTime();
                alarmTimeouts[alarm.Name] = setTimeout(function () {
                    alert("Alarm: " + alarm.Name);
                }, timeDifference); 
                toggleButton.textContent = "Disable"; 
                toggleButton.classList.remove("btn-secondary"); 
                toggleButton.classList.add("btn-danger"); 
            }
        }
    </script>
</body>
</html>
