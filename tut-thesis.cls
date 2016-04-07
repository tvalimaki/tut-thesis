% `tut-thesis.cls' provides a document class more or less compliant
% with the TUT thesis guidelines.
% Newest versions available under https://github.com/tvalimaki/tut-thesis
%
% Author: Tuomas Välimäki
%         tuomas.s.valimaki@tut.fi
%
% This file may be distributed and/or modified under the GNU Public License.
% http://www.gnu.org/licenses/gpl-3.0.en.html

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{tut-thesis}[2016/04/07 Extension to basic LaTeX document class 'book']

\DeclareOption{main=english}{%
    \PassOptionsToPackage{\CurrentOption}{babel}%
    \def\main@langu@ge{english}}
\DeclareOption{main=finnish}{%
    \PassOptionsToPackage{\CurrentOption}{babel}%
    \def\main@langu@ge{finnish}}
\DeclareOption{english}{\PassOptionsToPackage{\CurrentOption}{babel}}
\DeclareOption{finnish}{\PassOptionsToPackage{\CurrentOption}{babel}}

\ProcessOptions\relax
% Load the basic template 'book.cls'. 
\LoadClassWithOptions{book}

% Load required packages
\RequirePackage[T1]{fontenc} 	% proper font encoding for accented characters
\RequirePackage[utf8]{inputenc} % stop living in the medieval times and use utf8 input encoding
\RequirePackage{babel}          % translations and correct hyphenation
\RequirePackage[inner=4cm,outer=2cm,top=2.5cm,bottom=2.5cm]{geometry} % define page margins
\RequirePackage[labelsep=space,labelfont=bf,it,textfont=it]{caption} % figure and table captions
\RequirePackage[labelfont=up]{subcaption} % subfigure and subtable captions
\RequirePackage[scaled=0.8]{beramono} % better looking typewriter font
\RequirePackage[titletoc]{appendix} % appendix formatting
\RequirePackage{titlesec} 		% title formatting
\RequirePackage{fancyhdr} 		% header and footer formatting
\RequirePackage{parskip} 		% paragraph spacing that doesn't ruin TOC
\RequirePackage{etoolbox}		% tools to forking commands
\RequirePackage{setspace}		% provides line spacing
\RequirePackage{refcount} 		% reference handling
\RequirePackage[titles]{tocloft} % toc formatting
\RequirePackage[nostyles,nopostdot,nonumberlist,nogroupskip,xindy]{glossaries} % handles glossaries
\RequirePackage{ifthen}			% conditionals
\RequirePackage[hidelinks]{hyperref} % handles cross-referencing and produces hyperlinks
\RequirePackage{longtable} 		% tables that span multiple pages
\RequirePackage{tabu} 			% advanced tabular environment that provides e.g. automatic calculation of column widths
\RequirePackage{algorithm} 		% algorithm environment

%-----------------------------------------------------------------
% Define macros
%-----------------------------------------------------------------
\DeclareRobustCommand\title{\@ifnextchar[\@title@ii\@title@i}
\newcommand\@title@i[1]{\def\@title{#1}}
\newcommand\@title@ii[2][]{\def\@title{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@title{\@latex@warning@no@line{No \noexpand\title given}}

\DeclareRobustCommand\thesistype{\@ifnextchar[\@thesistype@ii\@thesistype@i}
\newcommand\@thesistype@i[1]{\def\@thesistype{#1}}
\newcommand\@thesistype@ii[2][]{\def\@thesistype{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@thesistype{\@latex@warning@no@line{No \noexpand\thesistype given}}

\DeclareRobustCommand\examiner{\@ifnextchar[\@examiner@ii\@examiner@i}
\newcommand\@examiner@i[1]{\def\@examiner{#1}}
\newcommand\@examiner@ii[2][]{\def\@examiner{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@examiner{\@latex@warning@no@line{No \noexpand\examiner given}}

\DeclareRobustCommand\extrainfo{\@ifnextchar[\@extrainfo@ii\@extrainfo@i}
\newcommand\@extrainfo@i[1]{\def\@extrainfo{#1}}
\newcommand\@extrainfo@ii[2][]{\def\@extrainfo{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@extrainfo{\@latex@warning@no@line{No \noexpand\extrainfo given}}

\DeclareRobustCommand\keywords{\@ifnextchar[\@keywords@ii\@keywords@i}
\newcommand\@keywords@i[1]{\def\@keywords{#1}}
\newcommand\@keywords@ii[2][]{\def\@keywords{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@keywords{\@latex@warning@no@line{No \noexpand\keywords given}}

\DeclareRobustCommand\programme{\@ifnextchar[\@programme@ii\@programme@i}
\newcommand\@programme@i[1]{\def\@programme{#1}}
\newcommand\@programme@ii[2][]{\def\@programme{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@programme{\@latex@warning@no@line{No \noexpand\programme given}}

\DeclareRobustCommand\major{\@ifnextchar[\@major@ii\@major@i}
\newcommand\@major@i[1]{\def\@major{#1}}
\newcommand\@major@ii[2][]{\def\@major{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@major{\@latex@warning@no@line{No \noexpand\major given}}

\DeclareRobustCommand\location{\@ifnextchar[\@location@ii\@location@i}
\newcommand\@location@i[1]{\def\@location{#1}}
\newcommand\@location@ii[2][]{\def\@location{\iflanguage{\main@langu@ge}{#2}{#1}}}
\def\@location{\@latex@warning@no@line{No \noexpand\location given}}

\def\pagedifference#1#2{\number\numexpr\getpagerefnumber{#2}-\getpagerefnumber{#1}\relax}

\protected\def\and{\unskip, } % Oxford comma is the default
%\protected\def\and{} % this would disable the Oxford comma

\def\prnt@xmr#1\and#2\nil{%
  \edef\test{#2}%
  \ifx\test\@empty #1\else #1\expandafter\prnt@xmr@i#2\nil\fi%
}
\def\prnt@xmr@i#1\and#2\nil{%
  \edef\test{#2}%
  \ifx\test\@empty \examinersep\space#1\else \unskip, #1\expandafter\prnt@xmr@ii#2\nil\fi%
}
\def\prnt@xmr@ii#1\and#2\nil{%
  \edef\test{#2}%
  \ifx\test\@empty \and \examinersep\space#1\else \unskip, #1\expandafter\prnt@xmr@ii#2\nil\fi%
}
\def\tst@xmr#1\and#2\nil{%
  \edef\test{#2}%
  \ifx\test\@empty \examinername\else \examinernamepl\fi%
}
\newcommand\prntexaminer{%
  {%
  \iflanguage{finnish}{\protected\def\and{}}{}%
  \edef\names{\@examiner}%
  \expandafter\prnt@xmr\names\and\nil%
  }%
}
\newcommand\testexaminer{%
    \edef\names{\@examiner}%
    \expandafter\tst@xmr\names\and\nil%
}
\newcommand\printexaminer{\testexaminer: \prntexaminer}

% translations
\newcommand{\examinername}{%
  \@ifundefined{examinername@\languagename}%
    {Examiner}%
    {\@nameuse{examinername@\languagename}}%
}
\newcommand{\examinernamepl}{%
  \@ifundefined{examinernamepl@\languagename}%
    {Examiners}%
    {\@nameuse{examinernamepl@\languagename}}%
}
\newcommand{\examinersep}{%
  \@ifundefined{examinersep@\languagename}%
    {and}%
    {\@nameuse{examinersep@\languagename}}%
}
\newcommand{\examinername@finnish}{Tarkastaja}
\newcommand{\examinernamepl@finnish}{Tarkastajat}
\newcommand{\examinersep@finnish}{ja}

%-----------------------------------------------------------------
% TOC formatting
%-----------------------------------------------------------------
\AtBeginDocument{%
\let\oldcontentsline\contentsline
\def\contentsline#1#2{%
	\expandafter\ifx\csname l@#1\endcsname\l@chapter
		\expandafter\@firstoftwo
	\else
		\expandafter\@secondoftwo
	\fi
	{%
		\oldcontentsline{#1}{\MakeUppercase{#2}}%
	}{%
		\oldcontentsline{#1}{#2}%
	}%
}%
\setlength{\cftbeforechapskip}{0pt} % remove space before chapters
\renewcommand{\cftchapfont}{\normalfont} % typeset entries with normalfont
\renewcommand{\cftchapleader}{\cftdotfill{\cftdotsep}} % use dots as leaders even for chapters
\renewcommand{\cftchappagefont}{\normalfont} % typeset pagenumber with normalfont
\setlength{\cftfigindent}{0pt} % don't indent figure list
\setlength{\cfttabindent}{0pt} % don't indent table list
}

% Remove space between table and figure caption entries between chapters
\let\oldlistoftables\listoftables
\def\listoftables{%
	\begingroup
	\renewcommand*{\addvspace}[1]{}
	\oldlistoftables
	\endgroup
}
\let\oldlistoffigures\listoffigures
\def\listoffigures{%
	\begingroup
	\renewcommand*{\addvspace}[1]{}
	\oldlistoffigures
	\endgroup
}
\let\oldlistofalgorithms\listofalgorithms
\def\listofalgorithms{%
	\begingroup
	\renewcommand*{\addvspace}[1]{}
	\oldlistofalgorithms
	\endgroup
}
% make every \listof behave like the \listoffigures
\patchcmd{\listof}% <cmd>
  {\float@listhead}% <search>
  {\@namedef{l@#1}{\l@figure}\float@listhead}% <replace>
  {}{}% <success><failure>

%-----------------------------------------------------------------
% Glossary formatting
%-----------------------------------------------------------------
\newlength{\glsentrywidth}
\setlength{\glsentrywidth}{6em}
\newglossarystyle{tut-thesis}{%
	\renewenvironment{theglossary}{%
  		\begingroup%
  		\setlength{\LTpre}{0pt}%
  		\setlength{\LTpost}{0pt}%
  		\tabulinesep=0.6ex%
  		\begin{longtabu} to \textwidth {@{}p{\glsentrywidth}X@{}}
  	}{%
  		\end{longtabu}
  		\endgroup
  	}
	\renewcommand*{\glossaryheader}{}
	\renewcommand*{\glsgroupheading}[1]{}
	\renewcommand{\glossentry}[2]{}
	\renewcommand{\subglossentry}[3]{%
    	\glsentryitem{##2}\glstarget{##2}{\glossentryname{##2}} &
    	\Glossentrydesc{##2}\glspostdescription\space ##3\tabularnewline}
	\renewcommand*{\glossaryentryfield}[5]{%
    	\glstarget{##1}{##2} & ##3\glspostdescription\space ##5\\}
	\renewcommand*{\glossarysubentryfield}[6]{%
    	\glstarget{##2}{##3} & ##4\glspostdescription\space ##6\\}
}

\newglossary[nlg]{notation}{not}{ntn}{}
\setglossarystyle{tut-thesis}
\renewcommand{\glsglossarymark}[1]{\markboth{\MakeUppercase{#1}}{\MakeUppercase{#1}}}
\glsdisablehyper

%-----------------------------------------------------------------
% Document formatting
%-----------------------------------------------------------------
% PDF settings
\AtBeginDocument{%
\hypersetup{%
	pdfcreator = {\LaTeX{} with 'tut-thesis' package},
	bookmarksopen = true,
	bookmarksdepth = 2,% to show sections and subsections
	pdfauthor = {\@author},
	pdftitle = {\@title},
	pdfsubject = {\@thesistype},
	pdfkeywords = {\@keywords}}
}
% Set linespacing to 1.2
\setstretch{1.2}
% Allow pagebreaks for equations in align -environment
\allowdisplaybreaks 

% Alter some LaTeX defaults for better treatment of figures:
% See p.105 of "TeX Unbound" for suggested values.
% See pp. 199-200 of Lamport's "LaTeX" book for details.
%   General parameters, for ALL pages:
\renewcommand{\topfraction}{0.9}	% max fraction of floats at top
\renewcommand{\bottomfraction}{0.8}	% max fraction of floats at bottom
%   Parameters for TEXT pages (not float pages):
\setcounter{topnumber}{2} % max number of floats at top
\setcounter{bottomnumber}{2} % max number of float at bottom
\setcounter{totalnumber}{4}     % max number of float per any page
\setcounter{dbltopnumber}{2}    % for 2-column pages
\renewcommand{\dbltopfraction}{0.9}	% fit big float above 2-col. text
\renewcommand{\textfraction}{0.07}	% allow minimal text w. figs
%   Parameters for FLOAT pages (not text pages):
\renewcommand{\floatpagefraction}{0.7}	% require fuller float pages
% N.B.: floatpagefraction MUST be less than topfraction !!
\renewcommand{\dblfloatpagefraction}{0.7}	% require fuller float pages
% remember to use [htp] or [htpb] for placement
% setting the defaults to:
\renewcommand{\fps@figure}{htp}
\renewcommand{\fps@table}{htp}

% Titlepage
\renewcommand\maketitle{%
	\pagenumbering{gobble}%
	\begin{titlepage}%
	\null\vskip -.2cm%
	\includegraphics[width=8cm]{tty_tut_logo}%
	\vskip 6.8cm%
	\begingroup%
	\bf\large\sffamily%
	\MakeUppercase{\@author}\\%
	\MakeUppercase{\@title}%
	\endgroup%
	\vskip 12pt%
	\textsf{\@thesistype}%
	\vfill%
	\begin{flushright}%
		\begin{minipage}[t]{6.8cm}%
			\raggedright\sffamily%
			\begin{spacing}{1.0}%
				\printexaminer\\%
				\@extrainfo
			\end{spacing}%
		\end{minipage}%
	\end{flushright}%
	\vskip 1.5cm\null%
	\end{titlepage}%
}
% Abstract
\newlength{\miniparskip}
\setlength{\miniparskip}{\parskip}

\newenvironment{abstract}{%
	\chapter*{\iflanguage{english}{Abstract}{Tiivistelmä}}
	\sffamily
	\begin{spacing}{1.0}
		\raggedright
		\iflanguage{english}{TAMPERE UNIVERSITY OF TECHNOLOGY}{TAMPEREEN TEKNILLINEN YLIOPISTO}\\
		\@programme\\
		\textbf{\MakeUppercase{\@author}}: \@title\\
		\@thesistype, \pages\\
        {%
          \DTMlangsetup*{showdayofmonth=false}
		  \@date\\
        }%
		\iflanguage{english}{Major}{Pääaine}: \@major\\
		\printexaminer\\
		\iflanguage{english}{Keywords}{Avainsanat}: \@keywords
	\end{spacing}
	\normalfont
	\bigskip
	\begin{minipage}{\textwidth}
	\setlength{\parskip}{\miniparskip}
	\setstretch{1}
}{%
	\end{minipage}
}
% Preface
\newenvironment{preface}{%
    \chapter*{\iflanguage{english}{Preface}{Alkusanat}}
}{%
    \vskip\bigskipamount
    \@location, \@date
    \vskip 2\bigskipamount
    \emph{\@author}
}
% Header and footer formatting
\pagestyle{fancy}
\renewcommand{\sectionmark}[1]{\markright{\thesection.\ #1}{}}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter.\ \MakeUppercase{#1}}{}}
\fancyhf{}
\if@twoside%
	\rhead[\leftmark]{\thepage}
	\lhead[\thepage]{\rightmark}
\else
	\rhead[\rightmark]{\thepage}
	\lhead[\thepage]{\leftmark}
\fi
\fancypagestyle{plain}{%
	\fancyhf{}%
	\rhead[]{\thepage}%
	\lhead[\thepage]{}%
}
\renewcommand{\headrulewidth}{0pt}
\setlength\headheight{2.9ex}
\setlength\parskip{1.5ex plus 1ex minus .2ex}
% Titles for frontmatter
\appto\frontmatter{%
	\pagenumbering{gobble}%
	\titleformat{\chapter}[hang]%
		{\normalfont\sffamily\large\bfseries}%
		{\thechapter}{1em}{\MakeUppercase}%
	\titlespacing{\chapter}{0pt}{-1.8ex plus -1ex minus -.2ex}{1ex plus .2ex}%
}
% Start numbering at TOC
\appto\tableofcontents{%
	\pagenumbering{roman}%
}
% Titles for mainmatter
\appto\mainmatter{%
	\pagestyle{fancy}%
	\titleformat{\chapter}[hang]%
		{\normalfont\sffamily\Large\bfseries}%
		{\thechapter.}{1em}{\MakeUppercase}%
	\titleformat{\section}[hang]%
		{\normalfont\sffamily\large\bfseries}%
		{\thesection}{1em}{}%
	\titleformat{\subsection}[hang]%
		{\normalfont\sffamily\large\bfseries}%
		{\thesubsection}{1em}{}%
	\titlespacing{\chapter}{0pt}{*8}{*8}[2em]%
	\titlespacing{\section}{0pt}{*3}{*3}%
	\titlespacing{\subsection}{0pt}{*3}{*3}%
}
% Title for bibliography
\AtBeginDocument{%
	\let\oldprintbibliography\printbibliography
	\def\printbibliography[#1]{%
		\titleformat{\chapter}[hang]%
			{\normalfont\sffamily\large\bfseries}%
			{\thechapter}{1em}{\MakeUppercase}%
		\titlespacing{\chapter}{0pt}{-1.8ex plus -1ex minus -.2ex}{1ex plus .2ex}%
		\begingroup%
		\singlespacing%
		\setlength{\bibitemsep}{\parskip}%
		\oldprintbibliography[#1]%
		\endgroup%
        \label{endcontent}%
	}%
    % a macro to calculate the number of pages in the document
    \newcommand{\pages}{% 
        \pageref*{endcontent}~\iflanguage{english}{pages}{sivua}%
        \ifnum\pagedifference{endcontent}{endappendices}>0%
            \ifnum\pagedifference{endcontent}{endappendices}>1%
            , \pagedifference{endcontent}{endappendices}~\iflanguage{english}{Appendix pages}{liitesivua}%
            \else
            , 1~\iflanguage{english}{Appendix page}{liitesivu}%
            \fi
        \fi}
}
\AtEndDocument{\label{endappendices}}
% Title and formatting for appendices
\AtBeginEnvironment{appendices}{%
	\titleformat{\chapter}[hang]%
		{\normalfont\sffamily\large\bfseries}%
		{\MakeUppercase{\appendixname} \thechapter:}{1em}{\MakeUppercase}%
	\titlespacing{\chapter}{0pt}{-1.8ex plus -1ex minus -.2ex}{1ex plus .2ex}%
	\addtocontents{toc}{\bigskip\cftpagenumbersoff{chapter}}%
	\let\oldchapter\chapter%
	\def\chapter#1{\oldchapter{#1}\thispagestyle{empty}\pagestyle{empty}}%
}
\endinput
