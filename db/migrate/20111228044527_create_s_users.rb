# encoding: utf-8
class CreateSUsers < ActiveRecord::Migration
  def self.up
    execute <<SQL
CREATE TABLE `s_user` (
  `uid` varchar(40) NOT NULL,
  `uidfull` varchar(40) NOT NULL,
  `carrier` tinyint(4) NOT NULL,
  `t_device_id` int(11) default NULL,
  `entry_flg` tinyint(4) NOT NULL default '0',
  `pay_flg` tinyint(4) NOT NULL default '0',
  `a_id` varchar(100) default NULL,
  `entry_dt` datetime NOT NULL,
  `retire_dt` datetime default NULL,
  `passed_cnt` int(11) default '0',
  `insert_dt` datetime NOT NULL,
  `update_dt` datetime NOT NULL,
  PRIMARY KEY  (`uid`),
  KEY `s1_key` (`a_id`)
) ENGINE=InnoDB DEFAULT CHARSET=sjis;
SQL
  end

  def self.down
    execute "DROP TABLE `s_user`"
  end
end
