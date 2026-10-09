let selectedR = null;
let hoverPoint = null;
let savedPoints = [];
const apiUrl = "/fcgi-bin/point-server";
const r = document.querySelectorAll(".r-button");
r.forEach(button => {
    button.addEventListener("click", function(){
        r.forEach(btn => btn.classList.remove("active"));
        this.classList.add("active");
        selectedR = this.getAttribute("data-value");
        updateFormState();
        drawCanvas();
    })
})  

document.getElementById("clearButton").addEventListener("click", clearTable);
document.getElementById("YInput").addEventListener("input", handleYInput);

const canvas = document.getElementById("coordinate-plane");
canvas.addEventListener("mousemove", handleCanvasMove);
canvas.addEventListener("mouseleave", handleCanvasLeave);
canvas.addEventListener("click", handleCanvasClick);


document.addEventListener("DOMContentLoaded", () => {
    loadHistory();
    updateFormState();
    drawCanvas();
});

function clearTable(){
    clearHistory();
}


function showMessage(message){
    document.getElementById("header-message-text").textContent = message;
    document.getElementById("header-message").hidden = false;
}

function closeMessage(){
    document.getElementById("header-message").hidden = true;
}

function getValidationError(){
    const yVal = parseFloat(document.getElementById("YInput").value.trim().replace(',', '.'));
    const rVal = parseFloat(selectedR);
    let errorStr = "";

    if(isNaN(yVal) || !checkY(yVal)) errorStr += "Y должен находиться в диапазоне от (-3, 3).\n";
    if(isNaN(rVal)) errorStr += "Выберите R: 1, 1.5, 2, 2.5 или 3.\n";
    return errorStr;
}

function updateFormState(){
    const errorStr = getValidationError();
    updateSubmitState();

    if (errorStr !== "") {
        showMessage(errorStr);
    } else {
        closeMessage();
    }
}

function updateSubmitState(){
    document.getElementById("submitButton").disabled = getValidationError() !== "";
}

function handleYInput(event){
    let value = event.target.value
        .replace(/[^0-9.,-]/g, '')
        .replace(/(?!^)-/g, '');
    const separatorIndex = value.search(/[.,]/);

    if (separatorIndex !== -1) {
        value = value.slice(0, separatorIndex + 1)
            + value.slice(separatorIndex + 1).replace(/[.,]/g, '');
    }

    event.target.value = value;
    updateFormState();
}

function normalizeYInput(event){
    event.target.value = event.target.value.replace(',', '.');
}

async function submitForm(event){
    event.preventDefault();
    normalizeYInput({target: document.getElementById("YInput")});
    const xVal = parseInt(document.getElementById("x-select").value);
    const yVal = parseFloat(document.getElementById("YInput").value.trim().replace(',', '.'));
    const rVal = parseFloat(selectedR);
    const errorStr = getValidationError();

    if(errorStr != ""){
        showMessage(errorStr);
        return;
    }

    await submitPoint({x: xVal, y: yVal, r: rVal});
}

function checkY(y){
    return (y > -3) && (y < 3);
}

function checkHit(x, y, r){
    if(x <= 0 && y >= 0 && x >= -r && y <= r) return true;
    if(x <= 0 && y <= 0 && x >= -r && y >= -x - r) return true;
    if(x >= 0 && y >= 0 && x*x + y*y <= (r/2)*(r/2)) return true;
    return false;
}

function addTableRow(item){
    const tbody = document.getElementById("table-body");
    const ftime = formatGMTTime(new Date(item.time));
    const newRow = document.createElement("tr");

    newRow.insertCell().appendChild(document.createTextNode(item.x));
    newRow.insertCell().appendChild(document.createTextNode(item.y));
    newRow.insertCell().appendChild(document.createTextNode(item.r));
    newRow.insertCell().appendChild(document.createTextNode(ftime));

    let resultCell = newRow.insertCell();
    const status = getPointStatus(item);
    resultCell.textContent = status.text;
    resultCell.className = status.className;

    tbody.appendChild(newRow);
}

function getPointStatus(point){
    const x = Number(point.x);
    const y = Number(point.y);
    const rValue = Number(point.r);
    const isValid = Number.isFinite(x) && x >= -3 && x <= 5
        && Number.isFinite(y) && y > -3 && y < 3
        && Number.isFinite(rValue) && [1, 1.5, 2, 2.5, 3].includes(rValue);

    if (!isValid) {
        return {text: "Не валидна", className: "status-invalid"};
    }

    const hit = checkHit(x, y, rValue);
    return {text: hit ? "Попал" : "Промах", className: hit ? "status-hit" : "status-miss"};
}

function formatGMTTime(date){
    const time = date.toLocaleString("ru-RU", {
        day: "2-digit",
        month: "2-digit",
        year: "numeric",
        hour: "2-digit",
        minute: "2-digit",
        second: "2-digit"
    });
    const offset = -date.getTimezoneOffset() / 60;
    const sign = offset >= 0 ? "+" : "-";
    return `${time} GMT${sign}${Math.abs(offset)}`;
}

async function requestApi(method, point = null){
    const options = {method, headers: {}};
    if (point !== null) {
        options.headers["Content-Type"] = "application/x-www-form-urlencoded";
        options.body = new URLSearchParams(point);
    }
    const response = await fetch(apiUrl, options);
    const data = await response.json();
    if (!response.ok || !data.ok) {
        throw new Error(data.error || "Ошибка запроса к серверу.");
    }
    updateServerInfo(data);
    return data;
}

function displayHistory(history){
    savedPoints = history;
    const tbody = document.getElementById("table-body");
    tbody.replaceChildren();
    savedPoints.forEach(addTableRow);
    drawCanvas();
}

function updateServerInfo(data){
    const serverTime = new Date(data.serverTime).toLocaleString("ru-RU");
    document.getElementById("server-info").textContent =
        `Время сервера: ${serverTime}; время обработки: ${data.processingTimeMs} мс`;
}

async function submitPoint(point){
    try {
        const data = await requestApi("POST", point);
        displayHistory(data.history);
        hoverPoint = null;
        closeMessage();
    } catch (error) {
        showMessage(error.message);
    }
}

async function clearHistory(){
    try {
        const data = await requestApi("DELETE");
        displayHistory(data.history);
        showMessage("Таблица очищена.");
    } catch (error) {
        showMessage(error.message);
    }
}

function getCanvasCoordinates(event){
    const rect = canvas.getBoundingClientRect();
    const currR = parseFloat(selectedR);
    if(isNaN(currR)) return null;

    const scale = getCanvasScale(canvas.width, canvas.height);
    const x = (event.clientX - rect.left - canvas.width / 2) / scale;
    const y = (canvas.height / 2 - (event.clientY - rect.top)) / scale;
    if(x < -3 || x > 5 || y <= -3 || y >= 3) return null;
    return {x: Math.round(x * 100) / 100, y: Math.round(y * 100) / 100, r: currR};
}

function getCanvasScale(width, height){
    const padding = 20;
    const scaleX = (width - 2 * padding) / 10;
    const scaleY = (height - 2 * padding) / 6;
    return Math.min(scaleX, scaleY);
}

function handleCanvasMove(event){
    hoverPoint = getCanvasCoordinates(event);
    drawCanvas();
}

function handleCanvasLeave(){
    hoverPoint = null;
    drawCanvas();
}

function handleCanvasClick(event){
    const point = getCanvasCoordinates(event);
    if(point === null) return;

    submitPoint(point);
}

async function loadHistory(){
    try {
        const data = await requestApi("GET");
        displayHistory(data.history);
    } catch (error) {
        showMessage(error.message);
    }
}

function drawCanvas(x = null, y = null, r = null, isHit = null){
    const canvas = document.getElementById("coordinate-plane");
    const ctx = canvas.getContext("2d");
    
    const width = canvas.width;
    const height = canvas.height;
    const Xcenter = width/2;
    const Ycenter = height/2;
    const currR = r !== null ? r : (parseFloat(selectedR) || 0);
    
    const scale = getCanvasScale(width, height);

    ctx.clearRect(0, 0, width, height);

    if(currR != 0){
        ctx.fillStyle = "rgb(155, 155, 243)";
        ctx.fillRect(
            Xcenter - currR * scale,
            Ycenter - currR * scale,
            currR * scale,
            currR * scale
        );

        ctx.beginPath();
        ctx.moveTo(Xcenter, Ycenter);
        ctx.lineTo(Xcenter - currR * scale, Ycenter);
        ctx.lineTo(Xcenter, Ycenter + currR * scale);
        ctx.closePath();
        ctx.fill();

        ctx.beginPath();
        ctx.moveTo(Xcenter, Ycenter);
        ctx.arc(Xcenter, Ycenter, currR * scale / 2, -Math.PI / 2, 0, false);
        ctx.closePath();
        ctx.fill();
    }

    ctx.save();
    ctx.strokeStyle = "#440044";
    ctx.lineWidth = 1.5;
    ctx.setLineDash([6, 4]);
    ctx.beginPath();
    ctx.moveTo(Xcenter - 3 * scale, Ycenter - 3 * scale);
    ctx.lineTo(Xcenter + 5 * scale, Ycenter - 3 * scale);
    ctx.lineTo(Xcenter + 5 * scale, Ycenter + 3 * scale);
    ctx.lineTo(Xcenter - 3 * scale, Ycenter + 3 * scale);
    ctx.closePath();
    ctx.stroke();
    ctx.restore();

    ctx.strokeStyle = "black";
    ctx.lineWidth = 1.5;
    ctx.beginPath();
    ctx.moveTo(0, Ycenter);
    ctx.lineTo(width, Ycenter);
    ctx.moveTo(Xcenter, 0);
    ctx.lineTo(Xcenter, height);
    ctx.stroke();

    drawArrow(ctx, width, Ycenter, 0);
    drawArrow(ctx, Xcenter, 0, -Math.PI / 2);
    if(currR != 0) drawRMarks(ctx, Xcenter, Ycenter, currR, scale);

    ctx.fillStyle = "black";
    ctx.fillText("X", width - 16, Ycenter - 8);
    ctx.fillText("Y", Xcenter + 8, 16);

    savedPoints.forEach(point => {
        drawPoint(
            ctx,
            Xcenter + point.x * scale,
            Ycenter - point.y * scale,
            point.hit ? "green" : "red"
        );
    });

    if(hoverPoint !== null && currR !== 0){
        drawPoint(
            ctx,
            Xcenter + hoverPoint.x * scale,
            Ycenter - hoverPoint.y * scale,
            "blue"
        );
    }
}

function drawRMarks(ctx, Xcenter, Ycenter, r, scale){
    ctx.fillStyle = "black";
    ctx.strokeStyle = "black";
    ctx.lineWidth = 1;
    ctx.font = "12px sans-serif";
    const marks = [
        {value: -r, label: "-R"},
        {value: -r / 2, label: "-R/2"},
        {value: r / 2, label: "R/2"},
        {value: r, label: "R"}
    ];

    marks.forEach(mark => {
        const x = Xcenter + mark.value * scale;
        ctx.beginPath();
        ctx.moveTo(x, Ycenter - 4);
        ctx.lineTo(x, Ycenter + 4);
        ctx.stroke();
        ctx.fillText(mark.label, x - 10, Ycenter + 18);

        const y = Ycenter - mark.value * scale;
        ctx.beginPath();
        ctx.moveTo(Xcenter - 4, y);
        ctx.lineTo(Xcenter + 4, y);
        ctx.stroke();
        ctx.fillText(mark.label, Xcenter + 7, y + 4);
    });
}

function drawPoint(ctx, x, y, color){
    ctx.beginPath();
    ctx.arc(x, y, 5, 0, Math.PI * 2);
    ctx.fillStyle = color;
    ctx.fill();
}

function drawArrow(ctx, x, y, direction){
    const arrowSize = 8;
    ctx.save();
    ctx.translate(x, y);
    ctx.rotate(direction);
    ctx.beginPath();
    ctx.moveTo(0, 0);
    ctx.lineTo(-arrowSize, -arrowSize / 2);
    ctx.lineTo(-arrowSize, arrowSize / 2);
    ctx.closePath();
    ctx.fillStyle = "black";
    ctx.fill();
    ctx.restore();
}
