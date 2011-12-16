

A look at #scifund[^now]
======

Jaime Ashander
-----

[^now]: now using the awesome `knitr` package, need to set options to 'gfm' and `base.url` appropriately


# Linear Models #

Models selected using stepwise AIC (`step`) and most non-collinear terms. 




## percent funded ## 

Initial model
{% highlight r %}
lm.funded1 = lm(percent.funded ~ description_length + 
    total_contributions + fund_goal + multiple.contributions + 
    average.contribution, data = prj.stats)
{% endhighlight %}



Final model



{% highlight text %}
##                       Estimate Std. Error t value  Pr(>|t|)
## (Intercept)          5.065e-01  1.022e-01   4.957 1.061e-05
## description_length  -3.715e-05  1.959e-05  -1.897 6.430e-02
## total_contributions  1.114e-02  1.452e-03   7.676 1.025e-09
## fund_goal           -4.134e-05  1.046e-05  -3.950 2.722e-04
{% endhighlight %}



## average contribution ## 

Initial model



Final model



{% highlight text %}
##                          Estimate Std. Error t value Pr(>|t|)
## (Intercept)            -2.383e+02  9.704e+01  -2.456 0.017981
## description_length     -2.149e-03  1.550e-03  -1.387 0.172290
## fund_goal               1.299e-03  8.277e-04   1.570 0.123528
## multiple.contributions  2.847e+02  9.511e+01   2.993 0.004476
{% endhighlight %}



## initial conclusions ## 

### percentage funded: ###  

* funding goal negative 
* more contribs better 
* having multiple contribs didn’t help achieve full funding 
* longer description did not help, may slightly hurt 
* higher average contribution did not help

### average contribution: ###

* having multiple contribs per contributor may up the average
contribution, but nothing else seems to help 
* may be driven by a few outliers (see Figure 2)


## future work ## 

* differences by discipline?
* textual analysis
* any way to connect to social network? e.g., quanitify number of friends/followers?


# Figures #





Multipanel is split over average contribution (columns) and whether some contributors contributed multiple (rows).

{% highlight r %}
g + theme_bw() + geom_point(aes(fund_goal, percent.funded, 
    size = total_contributions, color = description_length)) + 
    facet_grid(multiple.contributions.bool ~ av.contrib.factor) + 
    scale_color_brewer(type = "seq")
{% endhighlight %}
![plot of chunk percent-funded](https://github.com/ashander/scifundstats/percent-funded.png)



{% highlight r %}
g + theme_bw() + geom_point(aes(multiple.contributions, 
    average.contribution, color = description_length, size = fund_goal)) + 
    scale_color_brewer(type = "seq")
{% endhighlight %}
![plot of chunk average-contribution](https://github.com/ashander/scifundstats/average-contribution.png){% highlight r %}

#g +theme_bw()+
#   geom_boxplot(aes(multiple.contributions.bool,
#   average.contribution))+
#   geom_point(aes(multiple.contributions.bool,
#   average.contribution, color=description_length,
#   size=fund_goal))+scale_color_brewer(type='seq')
{% endhighlight %}

