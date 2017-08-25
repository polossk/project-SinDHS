---
layout: post
title: "[C#] Hello World"
date: 2014-04-10 23:57:51 +0800
categories: notebook planguage
tags: Csharp
---
# 第一个C#控制台程序

这是个非常简单的程序，简单到只需要在VS新建项目，写上一句话就行了：

关键词是Console.WriteLine，具体有三种用法，回头再说！

## Program.cs
{% highlight csharp %}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace HelloWorld_Console
{
    class Program
    {
        static void Main(string[] args)
        {
            Console.WriteLine("Hello World, from C#");
            Console.ReadLine();
        }
    }
}
{% endhighlight %}


# 第一个C#WinFrom程序

自从有了MFC的不美好经验，果断对这些东西适应了不少。

建项目，拖控件，改属性，加代码。

四步搞定。

## HelloWorld.cs
{% highlight csharp %}
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace HelloWorld_WinForm
{
    public partial class frmHelloWorld : Form
    {
        public frmHelloWorld()
        {
            InitializeComponent();
        }

        private void btnShow_Click(object sender, EventArgs e)
        {
            this.lblDisplay.Text = "Hello World, WinForm Application.";
        }

        private void btnDispear_Click(object sender, EventArgs e)
        {
            this.lblDisplay.Text = "";
        }
    }
}
{% endhighlight %}

## HelloWorld.Designer.cs
{% highlight csharp %}
namespace HelloWorld_WinForm
{
    partial class frmHelloWorld
    {
        /// <summary>
        /// 必需的设计器变量。
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// 清理所有正在使用的资源。
        /// </summary>
        /// <param name="disposing">如果应释放托管资源，为 true；否则为 false。</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows 窗体设计器生成的代码

        /// <summary>
        /// 设计器支持所需的方法 - 不要
        /// 使用代码编辑器修改此方法的内容。
        /// </summary>
        private void InitializeComponent()
        {
            this.lblDisplay = new System.Windows.Forms.Label();
            this.btnShow = new System.Windows.Forms.Button();
            this.btnDispear = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // lblDisplay
            // 
            this.lblDisplay.AutoSize = true;
            this.lblDisplay.BackColor = System.Drawing.SystemColors.Window;
            this.lblDisplay.Location = new System.Drawing.Point(41, 124);
            this.lblDisplay.Name = "lblDisplay";
            this.lblDisplay.Size = new System.Drawing.Size(0, 12);
            this.lblDisplay.TabIndex = 0;
            // 
            // btnShow
            // 
            this.btnShow.Location = new System.Drawing.Point(59, 164);
            this.btnShow.Name = "btnShow";
            this.btnShow.Size = new System.Drawing.Size(75, 23);
            this.btnShow.TabIndex = 1;
            this.btnShow.Text = "显示";
            this.btnShow.UseVisualStyleBackColor = true;
            this.btnShow.Click += new System.EventHandler(this.btnShow_Click);
            // 
            // btnDispear
            // 
            this.btnDispear.Location = new System.Drawing.Point(151, 164);
            this.btnDispear.Name = "btnDispear";
            this.btnDispear.Size = new System.Drawing.Size(75, 23);
            this.btnDispear.TabIndex = 2;
            this.btnDispear.Text = "消失";
            this.btnDispear.UseVisualStyleBackColor = true;
            this.btnDispear.Click += new System.EventHandler(this.btnDispear_Click);
            // 
            // frmHelloWorld
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 12F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(284, 261);
            this.Controls.Add(this.btnDispear);
            this.Controls.Add(this.btnShow);
            this.Controls.Add(this.lblDisplay);
            this.Name = "frmHelloWorld";
            this.Text = "Hello World";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label lblDisplay;
        private System.Windows.Forms.Button btnShow;
        private System.Windows.Forms.Button btnDispear;
    }
}
{% endhighlight %}
## Program.cs
{% highlight csharp %}
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace HelloWorld_WinForm
{
    static class Program
    {
        /// <summary>
        /// 应用程序的主入口点。
        /// </summary>
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.SetCompatibleTextRenderingDefault(false);
            Application.Run(new frmHelloWorld());
        }
    }
}
{% endhighlight %}
