<?php
session_start();
session_destroy();
?>
<script language="javascript">
    alert("Anda yakin akan logout");
    document.location = "login.php";
</script>
