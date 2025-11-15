<div class="user-info">
    <span>Welcome, ${sessionScope.adminName}</span>
    <form action="${pageContext.request.contextPath}/logout" method="get">
        <button type="submit">Logout</button>
    </form>
</div>

<style>
.user-info {
    position: fixed;
    top: 10px;
    right: 20px;
    display: flex;
    align-items: center;
    gap: 10px;
    background: none;
    z-index: 1000;
}

.user-info span {
    color: #333;
    font-weight: 500;
}

.user-info button {
    background-color: #e74c3c;
    color: white;
    border: none;
    padding: 6px 10px;
    border-radius: 4px;
    cursor: pointer;
    font-size: 14px;
}

.user-info button:hover {
    background-color: #c0392b;
}
</style>
