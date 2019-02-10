<?php
// https://drupal.stackexchange.com/questions/195307/how-to-create-nodes-from-shell-script-at-server

for ($i=0; $i < 100; $i++){
    // Expect title as $args[1] and body as $args[2]
    $node = new stdClass();  // Create a new node object
    $node->type = 'article';  // Content type
    $node->language = LANGUAGE_NONE;  // Or e.g. 'en' if locale is enabled
    node_object_prepare($node);  //Set some default values

    $node->title = "Article Title";
    $node->body[$node->language][0]['value'] = "<img src='../../../../../../../../../../../etc/spongebob.jpg' />\n<img src='http://localhost:6666' />";
    $node->body[$node->language][0]['format'] = "full_html";

    $node->status = 1;   // (1 or 0): published or unpublished
    $node->promote = 1;  // (1 or 0): promoted to front page or not
    $node->sticky = 0;  // (1 or 0): sticky at top of lists or not
    $node->comment = 1;  // 2 = comments open, 1 = comments closed, 0 = comments hidden
    // Add author of the node
    $node->uid = 1;

    // Save the node
    node_save($node);
}
