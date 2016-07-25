\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{mitthesis}[1999/10/20]

\def\mystretch{1.5}		% Double spacing hack
\DeclareOption{doublespace}{}	% This is default
				% So we do not read this style twice
\DeclareOption{singlespace}{		% If he explicitly wants single spacing
    \typeout{Single spaced}
    \def\mystretch{1}}	

%% `vi' and `upcase' document style options.  Krishna Sethuraman (1990)
\newcount\vithesis
\DeclareOption{vi}{\typeout{Course VI/VIII thesis style.}\advance\vithesis by1}
\vithesis=0

\DeclareOption{upcase}{\typeout{Uppercase cover page.}
	\gdef\choosecase#1{\uppercase\expandafter{#1}}}
\def\choosecase#1{#1}

%% leftblank option by Kevin Fu
\newif\if@leftblank \@leftblankfalse

\DeclareOption{leftblank}{\typeout{Intentionally Leaving Pages Blank}
\@leftblanktrue}

%  Thesis looks much like report
\DeclareOption*{\PassOptionsToClass{\CurrentOption}{report}}
\ProcessOptions
\LoadClass{report}

% If the user wants single spacing, set baselinestretch=1.

\usepackage{setspace}

% Note - doublespace.sty has some float-related troubles in
% combination with graphics or color, and is not officially compliant
% with 2e.  setspace is a replacement which is 2e-compliant.

% Read the doublespace style that we got from Rochester:
%\input setdoublespace.sty 		

\def\baselinestretch{\mystretch}	% Double spacing hack

%%%%%%%  Set up margins and formatting params %%%

% Margins.
%  Note we want 1in top margin assuming no header line, so push header
%	into 1in margin.
%  Draft mode brings the header back down.

\setlength{\oddsidemargin}{0.25in}	% 1.25in left margin 
\setlength{\evensidemargin}{0.25in}	% 1.25in left margin (even pages)
\setlength{\topmargin}{0.0in}		% 1in top margin
\setlength{\textwidth}{6.0in}		% 6.0in text - 1.25in rt margin
\setlength{\textheight}{9in}		% Body ht for 1in margins
\addtolength{\topmargin}{-\headheight}	% No header, so compensate
\addtolength{\topmargin}{-\headsep}	% for header height and separation

% The next two macros compensate page style for headers and footers
% We only need them in page styles that USE headers and footers.
    % If we have a header, it must be 1in from top of page.
\def\pulldownheader{			% Shift header down 1in from top
    \addtolength{\topmargin}{\headheight}	
    \addtolength{\topmargin}{\headsep}	
    \addtolength{\textheight}{-\headheight}
    \addtolength{\textheight}{-\headsep}
}
    % If we have a footer, put it 1in up from bottom
\def\pullupfooter{				% Shift footer up
    \addtolength{\textheight}{-\footskip}
%    \addtolength{\textheight}{-\footheight}  %footheight doesn't
%    						exist in 2e
}

% Draft mark on the right side of left pages (outside)
% this mark is also the only one visible on single sided.
\newcommand{\draftrmark}{**DRAFT**} 
% Draft mark on the left side of right pages (outside)
\newcommand{\draftlmark}{**DRAFT**} % 

% Macros to make changing the Draft easier
\newcommand{\drmark}[1]{\renewcommand{\draftrmark}{#1}}
\newcommand{\dlmark}[1]{\renewcommand{\draftlmark}{#1}}
\newcommand{\dmark}[1]{\drmark{#1}\dlmark{#1}}

% Format for draft of thesis.  Define our own PageStyle -
% Just like headings, but has foot lines with the date and warning

\if@twoside         % If two-sided printing.
\def\ps@drafthead{
    \let\@mkboth\markboth
    \def\@oddfoot{\rm \today \hfil \sc \draftrmark}
    \def\@evenfoot{\sc \draftlmark \hfil \rm \today }
    \def\@evenhead{\rm \thepage\hfil \sl \leftmark}
    \def\@oddhead{\hbox{}\sl \rightmark \hfil \rm\thepage}
    \def\chaptermark##1{\markboth {\uppercase{\ifnum \c@secnumdepth >\m@ne
	\@chapapp\ \thechapter. \ \fi ##1}}{}}
    \def\sectionmark##1{\markright {\uppercase{\ifnum \c@secnumdepth >\z@
	\thesection. \ \fi ##1}}}
    \pulldownheader				% Bring header down from edge
    \pullupfooter				% Bring footer up
}
\else               % If one-sided printing.
\def\ps@drafthead{
    \let\@mkboth\markboth
    \def\@oddfoot{\rm \today \hfil \sc \draftrmark}
    \def\@oddhead{\hbox{}\sl \rightmark \hfil \rm\thepage}
    \def\chaptermark##1{\markright {\uppercase{\ifnum \c@secnumdepth >\m@ne
	\@chapapp\ \thechapter. \ \fi ##1}}}
    \pulldownheader				% Bring header down from edge
    \pullupfooter				% Bring footer up
}
\fi

% I redefine these formats that were defined in report.sty
% Definition of 'headings' page style 
%  Note the use of ##1 for parameter of \def\chaptermark inside the
%  \def\ps@headings.
%

\if@twoside					% If two-sided printing.
\def\ps@headings{\let\@mkboth\markboth
    \def\@oddfoot{}
    \def\@evenfoot{}		% No feet.
    \def\@evenhead{\rm \thepage\hfil \sl \leftmark}	% Left heading.
    \def\@oddhead{\hbox{}\sl \rightmark \hfil \rm\thepage}	% Right heading.
    \def\chaptermark##1{\markboth {\uppercase{\ifnum \c@secnumdepth >\m@ne
	\@chapapp\ \thechapter. \ \fi ##1}}{}}	
    \def\sectionmark##1{\markright {\uppercase{\ifnum \c@secnumdepth >\z@
	\thesection. \ \fi ##1}}}
    \pulldownheader				% Bring header down from edge
}
\else						% If one-sided printing.
\def\ps@headings{\let\@mkboth\markboth
    \def\@oddfoot{}
    \def\@evenfoot{}		%     No feet.
    \def\@oddhead{\hbox {}\sl \rightmark \hfil \rm\thepage}	% Heading.
    \def\chaptermark##1{\markright {\uppercase{\ifnum \c@secnumdepth >\m@ne
	\@chapapp\ \thechapter. \ \fi ##1}}}
    \pulldownheader				% Bring header down from edge
}
\fi

% Redefinition of 'myheadings' page style.  
%
\def\ps@myheadings{\let\@mkboth\@gobbletwo
    \def\@oddfoot{}
    \def\@evenfoot{}
    \def\sectionmark##1{}
    \def\subsectionmark##1{}
    \def\@evenhead{\rm \thepage\hfil\sl\leftmark\hbox {}}	%
    \def\@oddhead{\hbox{}\sl\rightmark \hfil \rm\thepage}	%
    \pulldownheader				% Bring header down from edge
}						

% Redefine '/chapter' to always start on an odd page.
% Should make no difference in singleside mode.
%
\if@leftblank
% Prints "THIS PAGE INTENTIONALLY LEFT BLANK" on blank pages.
\def\chapter{\clearpage\ifodd\c@page\else
   \hbox{}\par\vfill\centerline%
   {THIS PAGE INTENTIONALLY LEFT BLANK}%
   \vfill\newpage\fi
   \thispagestyle{plain}	% Page style of chapter page is 'plain'
   \global\@topnum\z@		% Prevents figures from going at top of page.
   \@afterindentfalse		% Suppresses indent in first paragraph.  Change
   \secdef\@chapter\@schapter}	% to \@afterindenttrue to have indent.
\else
\def\chapter{\cleardoublepage	% Starts new page.
   \thispagestyle{plain}	% Page style of chapter page is 'plain'
   \global\@topnum\z@		% Prevents figures from going at top of page.
   \@afterindentfalse		% Suppresses indent in first paragraph.  Change
   \secdef\@chapter\@schapter}	% to \@afterindenttrue to have indent.
\fi
% If using the report style, use - instead of . in the figure number.
\@ifundefined{thechapter}{}{\def\thefigure{\thechapter-\arabic{figure}}}