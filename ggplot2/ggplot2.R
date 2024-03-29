# A practical introduction to ggplot2
# gscontras
# 
# 6/8/2017
# 
# Preface
# This tutorial borrows heavily from Judith Degen’s Using ggplot2 to visualize data tutorial and the Introduction to R Graphics with ggplot2 from the Data Science Services at Harvard’s IQSS.
# 
# Introduction
# ggplot2 is a langauge for creating graphics in R. Its author, Hadley Wickham, based his language on “The Grammar of Graphics” (Wikinson, 2005).
# 
# Getting started
# You should have R installed. If you do not have R installed, then:
#   Go to http://cran.r-project.org and download and install R
#   Go to http://rstudio.com and download and install RStudio
# 
#Download the tutorial materials:
#   Go to https://github.com/gscontras/tutorials/ggplot2
#   Download ggplot2.zip
#   Extract the zip file; tutorial notes are available in .R, .Rmd, and .html formats
#   Open ggplot2.R in RStudio
#
# Install the ggplot2 package by typing install.packages("ggplot2") into your RStudio console. Then, load the ggplot2 package:
  
library(ggplot2)

# Why ggplot2?
# There are some clear advantages of ggplot2 over the base graphics system included with R:
#   consistent underlying grammar of graphics (Wilkinson, 2005)
#   mature and complete graphics system
#   many users and lots of documentation
#   ability to specify plot detail at a high level of abstraction
#   amazingly flexible
#   comprehensive theme system for polishing plot appearance
# Still, the IQSS tutorial points to some clear limitations:
#   3D graphics (see the rgl package instead)
#   Graph-theory type graphs with nodes and edges (see the igraph package instead)
#   Interactive graphics (see the ggvis package instead)
# 
# The Grammar of Graphics
# Graphics are data visualizations: mappings from data to aesthetic attributes of geometric objects. Building blocks of a graphic include:
#   data
#   aesthetic mappings from data to attributes
#   geometric objects
#   statistical transformations
#   scales
#   coordinate system
#   positional adjustments
#   facets for geting the same plot for different subsets of the data
#   For a handy guide to specifying details of your graphics, consult the ggplot2 reference.
# 
# A sample dataset
# The languageR package contains lots of handy information, including the lexdec dataset: lexical decsion latencies elicited from 21 subjects for 79 English nouns, with information tied to the participants and nouns.
# 
# Load the languageR package and the lexdec dataset:
  
library(languageR)
data(lexdec)
head(lexdec)

# A simple histogram
# Pro-tip: begin by setting the background to white instead of gray.

theme_set(theme_bw())

# You’ll also want to make sure you’ve set your working directory to the folder these files are in:
  
setwd("~/git/tutorials/ggplot2/")

# Suppose you want to visualize the data in lexdec. We can start with a histogram of the response time distribution. We start by calling the ggplot function, which looks for a dataframe argument and an aesthetics argument. In the aes argument, we specify the x-axis.

ggplot(lexdec, aes(x=RT))

# Now, we want to add a geom_histogram layer to our base plot:
  
ggplot(lexdec, aes(x=RT)) +
  geom_histogram()

# It’s always helpful to add informative axis labels:
  
ggplot(lexdec, aes(x=RT)) +
  geom_histogram() +
  xlab("Log-transformed lexical decision times") +
  ylab("Number of observations")

# Each of the geom layers has attributions of its own that you can specify. Here, we specify the binwidth of geom_histogram:
  
ggplot(lexdec, aes(x=RT)) +
  geom_histogram(binwidth=0.01) +
  xlab("Log-transformed lexical decision times") +
  ylab("Number of observations")

# To save a plot you’ve created, use ggsave. Be sure to fine-tune the width and height arguments to suit your needs.

ggsave("plots/rt_histogram.png",width=5,height=4)

# A scatterplot
# Often, histograms won’t suffice to visualize the patterns of data we’re interested in. To see how lexical decision times pattern as a function of word frequency, we can use the same dataset to create a scatterplot.
# 
# We begin as before, by suppling a dataframe and some aesthetics to ggplot2; now, we’ll want our x-axis to plot word frequency, while our y-axis plot lexical decision times.

ggplot(lexdec, aes(x=Frequency, y=RT))

# To this base we add our geom_point layer and some reasonable axis labels:
  
ggplot(lexdec, aes(x=Frequency, y=RT)) +
  geom_point() +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time")

# We can get a better sense of what’s going on in our data by adding a smoothing layer with geom_smooth. Here, we specify the method to lm (short for linear model) so that it draws the line of best fit:
  
ggplot(lexdec, aes(x=Frequency, y=RT)) +
  geom_point() +
  geom_smooth(method="lm") +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time")

# We can customise attributes of the plot, for example the color or size or shape or the opacity (i.e., alpha) of our points:
  
ggplot(lexdec, aes(x=Frequency, y=RT)) +
  geom_point(color="red",size=5,shape=8,alpha=0.1) +
  geom_smooth(method="lm") +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time")

# We can also adjust our x- and y-axis limits, which will zoom in on the plot while deleting points outside the specified range.

ggplot(lexdec, aes(x=Frequency, y=RT)) +
  geom_point(color="red",size=5,shape=8,alpha=0.25) +
  geom_smooth(method="lm") +
  xlim(c(2,3)) +
  ylim(c(6,6.5)) +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time")

# We can include a lot more information in our scatter plots by specifying various aesthetics. For example, we can color our points by the `Length’ of the words in question.

ggplot(lexdec, aes(x=Frequency, y=RT, color=Length)) +
  geom_point() +
  geom_smooth(method="lm") +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time") +
  labs(color="Word length\nin characters")

# Rather than treating Length as a continuous collection of intergers, we can treat it as a factor with discrete levels. Doing so will now draw a different smoothing line for each possible word Length.

ggplot(lexdec, aes(x=Frequency, y=RT, color=as.factor(Length))) +
  geom_point() +
  geom_smooth(method="lm") +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time") +
  labs(color="Word length\nin characters")

# We can also specify the shape aesthetic to communcation informatio, say the Class to which a given word belongs (animal vs. plant).

ggplot(lexdec, aes(x=Frequency, y=RT, color=as.factor(Length), shape=Class)) +
  geom_point() +
  geom_smooth(method="lm") +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time") +
  labs(color="Word length\nin characters", shape="Word class")

# This plot has gotten awfully busy with all this information. We can clean things up a bit by faceting the graphic by Length and Class, rather than including all of the information on a single plot.

ggplot(lexdec, aes(x=Frequency, y=RT)) +
  geom_point() +
  geom_smooth(method="lm") +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time") +
  facet_grid(Class~Length) 

# As before, we can add more information to our plots with aesthetics, for example color by the NativeLanguage of the participants.

ggplot(lexdec, aes(x=Frequency, y=RT, color=NativeLanguage)) +
  geom_point() +
  geom_smooth(method="lm") +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time") +
  facet_grid(Class~Length) 

# If you don’t like the default colors, feel free to choose your own.

ggplot(lexdec, aes(x=Frequency, y=RT, color=NativeLanguage)) +
  geom_point(alpha=0.25) +
  geom_smooth(method="lm") +
  scale_color_manual(values=c("blue","red")) +
  xlab("Log-transformed lemma frequency") +
  ylab("Log-transformed response time") +
  facet_grid(Class~Length) 

# A barplot
# Scatterplots are useful when it comes to visualizing lots of data, but sometimes you want to focus in on summary statistics like mean values. In that case, you’re more likely to want a barplot to visualize your results.
# 
# It’s important to remember that the point estimate of a mean is useless information without some sense of the variation in the data that led to that point estimate. We can communicate that information with error bars representing confidence intervals.
# 
# The following helper file will load the bootsSummary function, which calculates these confidence intervals for you.

source("helpers.R")

# Now, suppose we want to visualize the average response time for each possible word length. First we’ll use bootsSummary to calculate those values for us.

d_s = bootsSummary(data=lexdec, measurevar="RT", groupvars=c("Length"))
d_s

# We’ll feed this information into a new ggplot, this time using geom_bar.

ggplot(d_s,aes(x=Length,y=RT))+
  geom_bar(stat="identity")

# To add error bars that represent our confidence intervals, we use geom_errorbar.

ggplot(d_s,aes(x=Length,y=RT))+
  geom_bar(stat="identity") +
  geom_errorbar(aes(ymin=bootsci_low, ymax=bootsci_high, x=Length))

# We can pretty the plot up some by changing colors and attributes.

ggplot(d_s,aes(x=as.factor(Length),y=RT))+
  geom_bar(stat="identity",fill="lightgray",color="darkgray") +
  geom_errorbar(aes(ymin=bootsci_low, ymax=bootsci_high, x=as.factor(Length), width=0.25)) +
  coord_cartesian(ylim=c(6,7)) +
  xlab("Word length in characters") +
  ylab("Log-transformed response time")

# As before, we can add lots of information to this plot by specifying additional attributes. Suppose we want to keep track of the noun Class and NativeLanguage. We’ll need to compute new means that take these factors into account.

d_s2 = bootsSummary(data=lexdec, measurevar="RT", groupvars=c("Length","Class","NativeLanguage"))
head(d_s2)

# We can then use these values in a new barplot.

ggplot(d_s2,aes(x=as.factor(Length),y=RT,fill=NativeLanguage))+
  geom_bar(stat="identity", position=position_dodge()) +
  geom_errorbar(aes(ymin=bootsci_low, ymax=bootsci_high, x=as.factor(Length), width=0.25), position=position_dodge(0.9)) +
  coord_cartesian(ylim=c(6,7)) +
  xlab("Word length in characters") +
  ylab("Log-transformed response time") +
  facet_grid(Class~.)

# You might want to further customize the plot attributes, for example with custom colors.

ggplot(d_s2,aes(x=as.factor(Length),y=RT,fill=NativeLanguage))+
  geom_bar(stat="identity", position=position_dodge()) +
  geom_errorbar(aes(ymin=bootsci_low, ymax=bootsci_high, x=as.factor(Length), width=0.25), position=position_dodge(0.9)) +
  coord_cartesian(ylim=c(6,7)) +
  scale_fill_manual(values=c("blue","red")) +
  xlab("Word length in characters") +
  ylab("Log-transformed response time") +
  facet_grid(Class~.)

# Let’s simplify things a bit and focus in on the effect of NativeLanguage on RT.

d_s3 = bootsSummary(data=lexdec, measurevar="RT", groupvars=c("NativeLanguage"))
head(d_s3)

# We can then visualize these values.

ggplot(d_s3,aes(x=NativeLanguage,y=RT))+
  geom_bar(stat="identity", position=position_dodge(), fill="lightgray",color="darkgray") +
  geom_errorbar(aes(ymin=bootsci_low, ymax=bootsci_high, x=NativeLanguage, width=0.25), position=position_dodge(0.9)) +
  coord_cartesian(ylim=c(5,8)) +
  xlab("Native Langauge") +
  ylab("Log-transformed response time")

# But suppose in addition to the means and the confidence intervals, we want to get a sense of the actual observations that led to these values. We can plot these observations by adding a geom_jitter layer using the original RT values from the lexdec dataframe.

ggplot(d_s3,aes(x=NativeLanguage,y=RT))+
  geom_bar(stat="identity", position=position_dodge(), fill="lightgray",color="darkgray") +
  geom_jitter(data=lexdec,aes(y=RT),alpha=.25,color="red") +
  geom_errorbar(aes(ymin=bootsci_low, ymax=bootsci_high, x=NativeLanguage, width=0.25), position=position_dodge(0.9)) +
  coord_cartesian(ylim=c(5,8)) +
  xlab("Native Langauge") +
  ylab("Log-transformed response time")

# A violin plot
# Violin plots provide another means of visualizing the distribution of responses. To understand violin plots, we start by visualizing the density of a distribution, in this case the distribution of RTs.

ggplot(lexdec,aes(x=RT))+
  geom_density()

# We can add information to this plot with additonal aesthetics.

ggplot(lexdec,aes(x=RT,fill=NativeLanguage))+
  geom_density(alpha=0.5)

# A violin plot effectively flips this information on its side:
  
ggplot(lexdec,aes(y=RT,x=NativeLanguage))+
  geom_violin()

# To add in information about quartiles and outliers, we can include a geom_boxplot layer.

ggplot(lexdec,aes(y=RT,x=NativeLanguage))+
  geom_violin() +
  geom_boxplot(notch=T,width=.25)

# We could also add in information about the mean and confidence intervals; we’ve computed those values in d_s3 above.

ggplot(lexdec,aes(y=RT,x=NativeLanguage))+
  geom_violin() +
  geom_point(data=d_s3,aes(y=RT,x=NativeLanguage),shape=95,size=5) +
  geom_errorbar(data=d_s3,aes(ymin=bootsci_low, ymax=bootsci_high, x=NativeLanguage, width=0.25))

# And of course, we can customize the color information and other attributes.

ggplot(lexdec,aes(y=RT,x=NativeLanguage,fill=NativeLanguage))+
  geom_violin() +
  geom_point(data=d_s3,aes(y=RT,x=NativeLanguage),shape=95,size=5,color="white") +
  geom_errorbar(data=d_s3,aes(ymin=bootsci_low, ymax=bootsci_high, x=NativeLanguage, width=0.25),color="white") +
  scale_fill_manual(values=c("blue","red")) +
  xlab("Native Language") +
  ylab("Log-transformed response time") +
  guides(fill=FALSE)

