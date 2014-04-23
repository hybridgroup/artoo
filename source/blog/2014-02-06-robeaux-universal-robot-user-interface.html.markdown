---
page_title_show: true
title: Robeaux - The Universal Robot User Interface
page_title: Blog
date: 2014-02-06
tags: robots
author: Ron Evans
active_menu_blog: true
---

We're off to a nice start for 2014 with the release of version 1.6 of Artoo - Ruby on Robots ([http://artoo.io](http://artoo.io)), our first release of the year. We learned a lot from our great experience at RobotsConf ([http://robotsconf.com](http://robotsconf.com)), and this is just the first step forward in a series of new improvements for all of you, our loyal friends. This release adds some powerful new capabilities, as well as support for more hardware. 

First of all, the user interface to the API for all of our robotic platforms is now in a new separate library. Called Robeaux ([http://robeaux.io](http://robeaux.io)), it is a universal dashboard to robotic systems, written using AngularJS ([http://angularjs.org/](http://angularjs.org/)). We're now using it within the newest releases of Artoo, Cylon.js ([http://cylonjs.com](http://cylonjs.com)), and Gobot ([http://gobot.io](http://gobot.io)).

We've also added more hardware support. Artoo now has a keyboard adaptor and driver, so you can use a standard computer keyboard to control your robotic devices. Please note we do not recommend using a keyboard to fly anything more than simple maneuvers using a drone. Unless absolutely necessary. Or fun.

Another new driver is called the "MakeyButton". Inspired by the awesome MakeyMakey ([http://makeymakey.com](http://makeymakey.com)), this GPIO driver allows you to connect a high Ohm resistor to a digital pin on your Arduino or Raspberry Pi. Using this simple circuit, and our driver, you can control your robots with bananas, clay, or drawable circuitry.

Our Sphero ([http://gosphero.com](http://gosphero.com)) drivers have now had a major overhaul. They can now keep up with the speed of the higher powered Sphero 2.0. We have also added the ability to orient the Sphero front direction. You do need to know which way you are going at that velocity.

Last but certainly not least, we've updated the Artoo documentation to include better and more complete information. We've also added more examples. You have told us how important docs and examples are to help get started.

Make sure you follow us on Twitter at [@artooio](http://twitter.com/artooio) for the latest updates. We're excited about our first release of the year, and we're looking forward to hearing from you what you think about it, and what else you think we should be working on.
