class Sqaauto531ChangeTheWayToGetParametersUpdateEpAgesTable < ActiveRecord::Migration
  def up
    say 'SQAAUTO-531 Change the way to get parameters and use parameters in checking common methods'
    @connection = ActiveRecord::Base.connection

    say 'Structure for table "ep_ages"'
    @connection.execute 'DROP TABLE IF EXISTS `ep_ages`;'
    @connection.execute "CREATE TABLE `ep_ages` (
      `idages` int(4) NOT NULL AUTO_INCREMENT,
      `locale` varchar(10) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
      `storefront` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
      `agestring` varchar(20) COLLATE utf8_unicode_ci NOT NULL DEFAULT '',
      `position` int(4) NOT NULL DEFAULT '0',
      PRIMARY KEY (`idages`)
    ) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;"

    say 'Data for table "ep_ages"'
    @connection.execute "INSERT INTO `ep_ages` VALUES (1,'us','leappad','3 years',1),(2,'us','leappad','4 years',2),(3,'us','leappad','5 years',3),(4,'us','leappad','6 years',4),(5,'us','leappad','7 years and up',5),(6,'us','leapster','3 years',6),(7,'us','leapster','4 years',7),(8,'us','leapster','5 years',8),(9,'us','leapster','6 years',9),(10,'us','leapster','7 years and up',10),(11,'us','leapreader','3 years',11),(12,'us','leapreader','4 years',12),(13,'us','leapreader','5 years',13),(14,'us','leapreader','6 years',14),(15,'us','leapreader','7 years and up',15),(16,'au','leappad','3 years',16),(17,'au','leappad','4 years',17),(18,'au','leappad','5 years',18),(19,'au','leappad','6 years',19),(20,'au','leappad','7 years and up',20),(21,'au','leapster','3 years',21),(22,'au','leapster','4 years',22),(23,'au','leapster','5 years',23),(24,'au','leapster','6 years',24),(25,'au','leapster','7 years and up',25),(26,'au','leapreader','3 years',26),(27,'au','leapreader','4 years',27),(28,'au','leapreader','5 years',28),(29,'au','leapreader','6 years',29),(30,'au','leapreader','7 years and up',30),(31,'ca','leappad','3 years',31),(32,'ca','leappad','4 years',32),(33,'ca','leappad','5 years',33),(34,'ca','leappad','6 years',34),(35,'ca','leappad','7 years and up',35),(36,'ca','leapster','3 years',36),(37,'ca','leapster','4 years',37),(38,'ca','leapster','5 years',38),(39,'ca','leapster','6 years',39),(40,'ca','leapster','7 years and up',40),(41,'ca','leapreader','3 years',41),(42,'ca','leapreader','4 years',42),(43,'ca','leapreader','5 years',43),(44,'ca','leapreader','6 years',44),(45,'ca','leapreader','7 years and up',45),(46,'ie','leappad','3 years',46),(47,'ie','leappad','4 years',47),(48,'ie','leappad','5 years',48),(49,'ie','leappad','6 years',49),(50,'ie','leappad','7 years and up',50),(51,'ie','leapster','3 years',51),(52,'ie','leapster','4 years',52),(53,'ie','leapster','5 years',53),(54,'ie','leapster','6 years',54),(55,'ie','leapster','7 years and up',55),(56,'ie','leapreader','3 years',56),(57,'ie','leapreader','4 years',57),(58,'ie','leapreader','5 years',58),(59,'ie','leapreader','6 years',59),(60,'ie','leapreader','7 years and up',60),(61,'uk','leappad','3 years',61),(62,'uk','leappad','4 years',62),(63,'uk','leappad','5 years',63),(64,'uk','leappad','6 years',64),(65,'uk','leappad','7 years and up',65),(66,'uk','leapster','3 years',66),(67,'uk','leapster','4 years',67),(68,'uk','leapster','5 years',68),(69,'uk','leapster','6 years',69),(70,'uk','leapster','7 years and up',70),(71,'uk','leapreader','3 years',71),(72,'uk','leapreader','4 years',72),(73,'uk','leapreader','5 years',73),(74,'uk','leapreader','6 years',74),(75,'uk','leapreader','7 years and up',75),(76,'row','leappad','3 years',76),(77,'row','leappad','4 years',77),(78,'row','leappad','5 years',78),(79,'row','leappad','6 years',79),(80,'row','leappad','7 years and up',80),(81,'row','leapster','3 years',81),(82,'row','leapster','4 years',82),(83,'row','leapster','5 years',83),(84,'row','leapster','6 years',84),(85,'row','leapster','7 years and up',85),(86,'row','leapreader','3 years',86),(87,'row','leapreader','4 years',87),(88,'row','leapreader','5 years',88),(89,'row','leapreader','6 years',89),(90,'row','leapreader','7 years and up',90),(91,'fr_fr','leappad','3 ans',91),(92,'fr_fr','leappad','4 ans',92),(93,'fr_fr','leappad','5 ans',93),(94,'fr_fr','leappad','6 ans',94),(95,'fr_fr','leappad','7 ans et plus',95),(96,'fr_fr','leapster','3 ans',96),(97,'fr_fr','leapster','4 ans',97),(98,'fr_fr','leapster','5 ans',98),(99,'fr_fr','leapster','6 ans',99),(100,'fr_fr','leapster','7 ans et plus',100),(101,'fr_ca','leappad','3 ans',101),(102,'fr_ca','leappad','4 ans',102),(103,'fr_ca','leappad','5 ans',103),(104,'fr_ca','leappad','6 ans',104),(105,'fr_ca','leappad','7 ans et plus',105),(106,'fr_ca','leapster','3 ans',106),(107,'fr_ca','leapster','4 ans',107),(108,'fr_ca','leapster','5 ans',108),(109,'fr_ca','leapster','6 ans',109),(110,'fr_ca','leapster','7 ans et plus',110),(111,'fr_row','leappad','3 ans',111),(112,'fr_row','leappad','4 ans',112),(113,'fr_row','leappad','5 ans',113),(114,'fr_row','leappad','6 ans',114),(115,'fr_row','leappad','7 ans et plus',115),(116,'fr_row','leapster','3 ans',116),(117,'fr_row','leapster','4 ans',117),(118,'fr_row','leapster','5 ans',118),(119,'fr_row','leapster','6 ans',119),(120,'fr_row','leapster','7 ans et plus',120);"
  end
end