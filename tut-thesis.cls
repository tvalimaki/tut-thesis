% `tut-thesis.cls' provides a document class more or less compliant
% with the TUT thesis guidelines.
% Newest versions available under https://github.com/tvalimaki/tut-thesis
%
% Author: Tuomas Välimäki (6 May 2015)
%         tuomas.s.valimaki@tut.fi
%
% This file may be distributed and/or modified under the GNU Public License.
% http://www.gnu.org/licenses/gpl-3.0.en.html

\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{tut-thesis}[2015/05/06 Extension to basic LaTeX document class 'book']

% Load the basic template 'book.cls'. 
\LoadClassWithOptions{book}

% Load required packages
\RequirePackage[T1]{fontenc} 	% proper font encoding for accented characters
\RequirePackage[utf8]{inputenc} % stop living in the medieval times and use utf8 input encoding
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
\RequirePackage{glossary-super}	% used glossary style
\RequirePackage{ifthen}			% conditionals
\RequirePackage[hidelinks]{hyperref} % handles cross-referencing and produces hyperlinks

%-----------------------------------------------------------------
% Define macros
%-----------------------------------------------------------------
\def\title#1#2{\def\@title{\iflanguage{english}{#2}{#1}}}
\def\@title{\@latex@warning@no@line{No \noexpand\title given}}
\def\subtitle#1{\def\@subtitle{#1}}
\def\@subtitle{\@latex@warning@no@line{No \noexpand\subtitle given}}
\def\thesistype#1#2{\def\@thesistype{\iflanguage{english}{#2}{#1}}}
\def\@thesistype{\@latex@warning@no@line{No \noexpand\thesistype given}}
\def\examiner#1#2#3{\def\@examiner{\iflanguage{english}{#2}{#1}~#3}}
\def\@examiner{\@latex@warning@no@line{No \noexpand\examiner given}}
\def\approved#1{\def\@approved{#1}}
\def\@approved{\@latex@warning@no@line{No \noexpand\approved given}}
\def\keywords#1#2{\def\@keywords{\iflanguage{english}{#2}{#1}}}
\def\@keywords{\@latex@warning@no@line{No \noexpand\keywords given}}
\def\programme#1#2{\def\@programme{\iflanguage{english}{#2}{#1}}}
\def\@programme{\@latex@warning@no@line{No \noexpand\programme given}}
\def\major#1#2{\def\@major{\iflanguage{english}{#2}{#1}}}
\def\@major{\@latex@warning@no@line{No \noexpand\major given}}

\def\pagedifference#1#2{\number\numexpr\getpagerefnumber{#2}-\getpagerefnumber{#1}\relax}

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

%-----------------------------------------------------------------
% Glossary formatting
%-----------------------------------------------------------------
\newglossary[nlg]{notation}{not}{ntn}{}
\setglossarystyle{super}
\glsdisablehyper
% Macros for defining entries
\newcommand{\glosentry}[3][]{ % name, description
	\newglossaryentry{#2}{%
		name={#2},
		description={#3},
		#1}
	\glsadd{#2}
}
\newcommand{\acrentry}[4][]{ % short, long, description
	\newacronym[description={#3\ifthenelse{\equal{#4}{}}{}{, {#4}}},#1]{#2}{#2}{#3}
	\glsadd{#2}
}
\newcommand{\notentry}[4][]{ % sort, name, description
    \newglossaryentry{not:#2}{%
        type=notation,
        sort={#2},
        name={#3},
        description={#4},
        #1}
    \glsadd{not:#2}
}

%-----------------------------------------------------------------
% Document formatting
%-----------------------------------------------------------------
% PDF settings
\AtBeginDocument{%
\hypersetup{%
	pdfcreator    = {\LaTeX{} with 'tut-thesis' package},
	% pdfproducer   = {\LaTeX{}},% will/should be set automatically to the correct TeX engine used
	bookmarksopen = true,
	bookmarksdepth= 2,% to show sections and subsections
	pdfauthor     = {\@author},
	pdftitle      = {\@title},
	pdfsubject    = {\@subtitle},
	pdfkeywords   = {\@keywords}}
}
% Titlepage
\renewcommand\maketitle{%
	\pagenumbering{gobble}%
	\begin{titlepage}%
	\null\vskip -.5cm%
	\includegraphics[width=8cm]{tty_tut_logo}%
	\vskip 6.8cm%
	\MakeUppercase{\bf\large\sffamily%
		\@author\\%
		\@title}%
	\vskip 12pt%
	\textsf{\@subtitle}%
	\vfill%
	\begin{flushright}%
		\begin{minipage}[c]{6.8cm}%
			\raggedright\sffamily%
			\begin{spacing}{1.0}%
				\iflanguage{english}{Examiner}{Tarkastaja}: \@examiner\\%
				\@approved
			\end{spacing}%
		\end{minipage}%
	\end{flushright}%
	\vskip 2cm\null%
	\end{titlepage}%
}
% Abstract
\newcommand\abstract[1]{%
	\chapter*{\iflanguage{english}{Abstract}{Tiivistelmä}}
	\sffamily
	\begin{spacing}{1.0}
		\raggedright
		\iflanguage{english}{TAMPERE UNIVERSITY OF TECHNOLOGY}{TAMPEREEN TEKNILLINEN YLIOPISTO}\\
		\@programme\\
		\textbf{\MakeUppercase{\@author}}: \@title\\
		\@thesistype, \pages\\
		\@date\\
		\iflanguage{english}{Major}{Pääaine}: \@major\\
		\iflanguage{english}{Examiner}{Tarkastaja}: \@examiner\\
		\iflanguage{english}{Keywords}{Avainsanat}: \@keywords
	\end{spacing}
	\normalfont
	\bigskip

	#1
}
% Header and footer formatting
\pagestyle{fancy}
\renewcommand{\sectionmark}[1]{\markright{\thesection.\ #1}{}}
\renewcommand{\chaptermark}[1]{\markboth{\thechapter.\ #1}{}}
\fancyhf{}
\rhead[\rightmark]{\thepage}
\lhead[\thepage]{\leftmark}
\fancypagestyle{plain}{%
	\fancyhf{}%
	\rhead[]{\thepage}%
	\lhead[\thepage]{}%
}
\renewcommand{\headrulewidth}{0pt}
\setlength\headheight{2.9ex}
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
	\titlespacing{\chapter}{0pt}{5.03ex plus 1ex minus .2ex}{8.13ex plus .2ex}%
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
		\setlength{\bibitemsep}{1ex}%
		\oldprintbibliography[#1]%
		\endgroup%
	}
}
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
% Date formatting
\newcommand*{\Monthnamefinnish}[1]{%
\ifcase#1\relax
	\or Tammikuu%
	\or Helmikuu%
	\or Maaliskuu%
	\or Huhtikuu%
	\or Toukokuu%
	\or Kesäkuu%
	\or Heinäkuu%
	\or Elokuu%
	\or Syyskuu%
	\or Lokakuu%
	\or Marraskuu%
	\or Joulukuu%
\fi
}