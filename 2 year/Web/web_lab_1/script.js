let selectedR = null;
let hoverPoint = null;
let savedPoints = [];
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
    document.getElementById("table-body").replaceChildren();
    localStorage.removeItem("points-history");
    savedPoints = [];
    showMessage("Таблица очищена.");
    drawCanvas();
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
    const rVal = parseInt(selectedR);
    let errorStr = "";

    if(isNaN(yVal) || !checkY(yVal)) errorStr += "Y должен находиться в диапазоне от (-3, 3).\n";
    if(isNaN(rVal)) errorStr += "R не выбран.\n";
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

function submitForm(event){
    event.preventDefault();
    normalizeYInput({target: document.getElementById("YInput")});
    const xVal = parseInt(document.getElementById("x-select").value);
    const yVal = parseFloat(document.getElementById("YInput").value.trim().replace(',', '.'));
    const rVal = parseInt(selectedR);
    
    const errorStr = getValidationError();

    if(errorStr != ""){
        showMessage(errorStr);
        return;
    }

    const isHit = checkHit(xVal, yVal, rVal);
    const time = new Date().toISOString();

    savePoint(xVal, yVal, rVal, isHit, time);
}

function checkY(y){
    return (y > -3) && (y < 3);
}

function checkHit(x, y, r){
    if(x >= 0 && y >= 0 && (x*x + y*y <= r*r)) return true;
    if(x >= 0 && y <= 0 && (y >= 2*x - r)) return true;
    if(x <= 0 && y <= 0 && (x >= -r/2 && y >= -r)) return true;
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

    tbody.insertBefore(newRow, tbody.firstChild);
}

function getPointStatus(point){
    const x = Number(point.x);
    const y = Number(point.y);
    const rValue = Number(point.r);
    const isValid = Number.isFinite(x) && x >= -4 && x <= 4
        && Number.isFinite(y) && y > -3 && y < 3
        && Number.isFinite(rValue) && [1, 2, 3, 4, 5].includes(rValue);

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

function saveToStorage(item){
    const history = JSON.parse(localStorage.getItem("points-history") || "[]");
    history.push(item);
    localStorage.setItem('points-history', JSON.stringify(history));
}

function savePoint(x, y, r, isHit, time = new Date().toISOString()){
    const point = {x, y, r, time, hit: isHit};
    savedPoints.push(point);
    addTableRow(point);
    saveToStorage(point);
    hoverPoint = null;
    drawCanvas(x, y, r, isHit);
}

function getCanvasCoordinates(event){
    const rect = canvas.getBoundingClientRect();
    const currR = parseFloat(selectedR);
    if(isNaN(currR)) return null;

    const scale = Math.min(canvas.width, canvas.height) / (2 * (currR + 1));
    const x = (event.clientX - rect.left - canvas.width / 2) / scale;
    const y = (canvas.height / 2 - (event.clientY - rect.top)) / scale;
    if(x < -4 || x > 4 || y <= -3 || y >= 3) return null;
    return {x: Math.round(x * 100) / 100, y: Math.round(y * 100) / 100, r: currR};
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

    savePoint(point.x, point.y, point.r, checkHit(point.x, point.y, point.r));
}

function loadHistory(){
    const history = JSON.parse(localStorage.getItem("points-history") || "[]");
    savedPoints = history.map(item => ({
        ...item,
        hit: getPointStatus(item).text === "Попал"
    }));
    localStorage.setItem("points-history", JSON.stringify(savedPoints));
    savedPoints.forEach(item => {
        addTableRow(item);
    });
}

function drawCanvas(x = null, y = null, r = null, isHit = null){
    const canvas = document.getElementById("coordinate-plane");
    const ctx = canvas.getContext("2d");
    
    const width = canvas.width;
    const height = canvas.height;
    const Xcenter = width/2;
    const Ycenter = height/2;
    const currR = r !== null ? r : (parseFloat(selectedR) || 0);
    
    const scale = currR !== 0 ? Math.min(width, height) / (2 * (currR + 1)) : 30;

    ctx.clearRect(0, 0, width, height);

    if(currR != 0){
        ctx.fillStyle = "rgb(155, 155, 243)";
        ctx.beginPath();
        ctx.moveTo(Xcenter, Ycenter);
        ctx.arc(Xcenter, Ycenter, currR * scale, -Math.PI / 2, 0, false);
        ctx.closePath();
        ctx.fill();

        ctx.fillRect(
            Xcenter - (currR / 2) * scale, 
            Ycenter, 
            (currR / 2) * scale, 
            currR * scale
        );

        ctx.beginPath();
        ctx.moveTo(Xcenter, Ycenter);                           
        ctx.lineTo(Xcenter + (currR / 2) * scale, Ycenter);    
        ctx.lineTo(Xcenter, Ycenter + currR * scale);         
        ctx.closePath();
        ctx.fill();

    }
    ctx.save();
    ctx.strokeStyle = "#440044";
    ctx.lineWidth = 1.5;
    ctx.setLineDash([6, 4]);
    ctx.beginPath();
    ctx.moveTo(Xcenter - 4 * scale, Ycenter - 3 * scale);
    ctx.lineTo(Xcenter + 4 * scale, Ycenter - 3 * scale);
    ctx.moveTo(Xcenter - 4 * scale, Ycenter + 3 * scale);
    ctx.lineTo(Xcenter + 4 * scale, Ycenter + 3 * scale);
    ctx.moveTo(Xcenter - 4 * scale, Ycenter - 3 * scale);
    ctx.lineTo(Xcenter - 4 * scale, Ycenter + 3 * scale);
    ctx.moveTo(Xcenter + 4 * scale, Ycenter - 3 * scale);
    ctx.lineTo(Xcenter + 4 * scale, Ycenter + 3 * scale);
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
    drawAxisMarks(ctx, Xcenter, Ycenter, width, height, scale);

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

function drawAxisMarks(ctx, Xcenter, Ycenter, width, height, scale){
    const axisPadding = 20;
    const maxX = Math.floor((Math.max(Xcenter, width - Xcenter) - axisPadding) / scale);
    const maxY = Math.floor((Math.max(Ycenter, height - Ycenter) - axisPadding) / scale);

    ctx.strokeStyle = "black";
    ctx.fillStyle = "black";
    ctx.lineWidth = 1;
    ctx.font = "11px sans-serif";

    for(let value = -maxX; value <= maxX; value++){
        if(value === 0) continue;
        const x = Xcenter + value * scale;
        ctx.beginPath();
        ctx.moveTo(x, Ycenter - 4);
        ctx.lineTo(x, Ycenter + 4);
        ctx.stroke();
        ctx.fillText(value, x - 4, Ycenter + 16);
    }

    for(let value = -maxY; value <= maxY; value++){
        if(value === 0) continue;
        const y = Ycenter - value * scale;
        ctx.beginPath();
        ctx.moveTo(Xcenter - 4, y);
        ctx.lineTo(Xcenter + 4, y);
        ctx.stroke();
        ctx.fillText(value, Xcenter + 7, y + 4);
    }
}